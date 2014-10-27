# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'impact_radius_api/version'

Gem::Specification.new do |spec|
  spec.name          = "impact_radius_api"
  spec.version       = ImpactRadiusAPI::VERSION
  spec.authors       = ["Kirk Jarvis"]
  spec.email         = ["zuuzlo@yahoo.com"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock", '~> 1.20.0'
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "addressable", "~> 2.3", ">= 2.3.6"
  spec.add_dependency "htmlentities", "~> 4.3", ">= 4.3.2"
  spec.add_dependency "httparty", "~> 0.13"
  spec.add_dependency "json", "~> 1.8", ">= 1.8.1"
  spec.add_dependency "recursive-open-struct", "~> 0.5", ">= 0.5.0"

  
end
