require 'docker'

require "docker_pid/version"
require "docker_pid/nvidia_smi"

module DockerPid
  class ProcessNotExist < Exception; end
  class NotDockerProcess < Exception; end

  module Host
    def self.exist_process?(pid)
      begin
        Process.getpgid(pid)
        true
      rescue Errno::ESRCH
        false
      end
    end

    def self.proc_cgroup(pid)
      begin
        p = Integer(pid)
        raise unless exist_process?(p)
      rescue => e
        raise ProcessNotExist.new("PID: #{pid}")
      end
      File.read("/proc/#{pid}/cgroup")
    end

    def self.docker_container_id(pid)
      cg = proc_cgroup(pid)
      m = cg.match(/\/docker\/(.+?)(\/|\n)/m)
      raise NotDockerProcess.new("PID: #{pid}") if m.nil?
      m[1]
    end
  end

  def self.container_info(container_id)
    c = Docker::Container.get(container_id)
    { container_id: container_id,
      name: c.info['Name'],
      image: c.info['Config']['Image'],
      ip: c.info['NetworkSettings']['IPAddress'],
      port_binding: c.info['HostConfig']['PortBindings']
    }
  end

  def self.container_ps(container_id)
    c = Docker::Container.get(container_id)
    chunks = []
    c.exec(%w(ps aux)) do |stream, chunk|
      chunks << chunk if stream == :stdout
    end
    chunks.join("\n")
  end
end
