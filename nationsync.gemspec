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
  s.description   = "Write a gem description"
  s.summary       = "Write a gem summary"
  s.homepage      = "http://github.com/dirk/nationsync"
  s.license       = "MIT"

  s.bindir        = 'bin'
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency 'rack',     '~> 1.5'
  s.add_dependency 'faraday',  '~> 0.8.8'
  s.add_dependency 'faraday_middleware', '~> 0.9.0'
  s.add_dependency 'thor',     '~> 0.18.1'
  s.add_dependency 'listen',   '~> 2.2.0'
  s.add_dependency 'highline', '~> 1.6.20'
  

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"
end
