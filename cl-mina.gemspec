# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cl_mina/version'

Gem::Specification.new do |spec|
  spec.name          = "cl-mina"
  spec.version       = ClMina::VERSION
  spec.authors       = ["Nathan Sharpe"]
  spec.email         = ["nathan@cliftonlabs.com"]
  spec.summary       = "Common deploy tasks and settings."
  spec.description   = "Designed for use in a fairly specific context, so probably not that versatile."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "generator_spec"

  spec.add_runtime_dependency "mina"
  spec.add_runtime_dependency "pg"
  spec.add_runtime_dependency "unicorn"
  spec.add_runtime_dependency "carrier-pigeon"
  spec.add_runtime_dependency "highline"
end
