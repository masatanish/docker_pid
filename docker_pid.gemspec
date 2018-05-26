# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "docker_pid/version"

Gem::Specification.new do |spec|
  spec.name          = "docker_pid"
  spec.version       = DockerPid::VERSION
  spec.authors       = ["masatanish"]
  spec.email         = ["masatanish@gmail.com"]

  spec.summary       = %q{Tool for finding dokcer container ID from pid of host.}
  spec.description   = %q{Tool for finding dokcer container ID from pid of host.}
  spec.homepage      = "https://github.com/masatanish/docker_pid"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "docker-api", ">= 1.34"
  spec.add_dependency "nvidia-smi"
  spec.add_dependency "sys-proctable"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
