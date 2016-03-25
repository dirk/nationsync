# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
# require 'nationsync/version'
require 'nationsync'

Gem::Specification.new do |s|
  s.name          = "nationsync"
  s.version       = NationSync::VERSION
  s.authors       = ["Dirk Gadsden"]
  s.email         = ["dirk@dirk.to"]
  s.description   = "Synchronize a folder with NationBuilder theme"
  s.summary       = "Synchronize a folder with NationBuilder theme through the theme API"
  s.homepage      = "http://github.com/dirk/nationsync"
  s.license       = "MIT"

  s.bindir        = 'bin'
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rack',     '~> 1.5'
  s.add_runtime_dependency 'faraday',  '~> 0.8'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.9'
  s.add_runtime_dependency 'thor',     '~> 0.19'
  s.add_runtime_dependency 'listen',   '~> 3.0'
  s.add_runtime_dependency 'highline', '~> 1.6'
  s.add_runtime_dependency 'mechanize', '~> 2.7'
  s.add_runtime_dependency 'httparty', '~> 0.13'


  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 11.1"
end
