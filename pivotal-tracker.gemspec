# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pivotal-tracker/version'

Gem::Specification.new do |spec|
  spec.name          = "pivotal-tracker"
  spec.version       = PivotalTracker::VERSION
  spec.authors       = ["Justin Smestad"]
  spec.email         = ["justin.smestad@gmail.com"]
  spec.summary       = %q{Ruby wrapper for the Pivotal Tracker API}
  spec.description   = %q{Ruby wrapper for the Pivotal Tracker API}
  spec.homepage      = "https://github.com/jsmestad/pivotal-tracker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0") - ['Guardfile', '.travis.yml']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "nokogiri-happymapper", ">= 0.5.4"
  spec.add_runtime_dependency "builder", ">= 0"
  spec.add_runtime_dependency "nokogiri", ">= 1.5.5"
  spec.add_runtime_dependency "crack", ">= 0"
  spec.add_runtime_dependency "rest-client", ">= 1.8.0"

  spec.add_development_dependency "activesupport", "<= 4.1"
  spec.add_development_dependency "rspec", ">= 3.0.0"
  spec.add_development_dependency "bundler", ">= 1.0.12"
  spec.add_development_dependency "jeweler", ">= 2.0.1"
  spec.add_development_dependency "stale_fish", "~> 1.3.0"
end

