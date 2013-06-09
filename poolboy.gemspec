# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poolboy/version'

Gem::Specification.new do |spec|
  spec.name          = "poolboy"
  spec.version       = Poolboy::VERSION
  spec.authors       = ["Sam"]
  spec.email         = ["sam@ninjapanda.co.uk"]
  spec.description   = %q{See the status of your Percona Server buffer pool}
  spec.summary       = %q{Poolboy lets you view the data in your buffer pool}
  spec.homepage      = "http://www.samlambert.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["poolboy"]
  spec.default_executable = 'poolboy'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mysql2"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
