require 'csv'
require 'nvidia-smi'

module NvidiaSmi
  class Process
    attr_reader :pid, :name, :memory, :gpu_index
    def initialize(pid, name, memory, uuid)
      @pid = pid.to_i
      @name = name
      @memory = memory.to_i
      @uuid = uuid
      @gpu_index = NvidiaSmi.index_by_uuid(uuid)
    end

  end

  def self.processes
    data = `nvidia-smi --query-compute-apps=pid,process_name,used_memory,gpu_uuid --format=csv,nounits,noheader`
    procs = []
    CSV.parse(data) do |row|
      row = row.map{|c| c.strip }
      procs << Process.new(*row)
    end
    procs
  end

  def self.index_by_uuid(uuid)
    gpu = NvidiaSmi.gpus.find{|g| g.uuid == uuid }
    @gpu_index = gpu.index.to_i
  end

end
