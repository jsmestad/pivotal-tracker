#!/usr/bin/env rake
begin
    require 'bundler/setup'
rescue LoadError
    puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "pivotal-tracker"
    gem.summary = %Q{Ruby wrapper for the Pivotal Tracker API}
    gem.email = "justin.smestad@gmail.com"
    gem.homepage = "http://github.com/jsmestad/pivotal-tracker"
    gem.authors = ["Justin Smestad", "Josh Nichols", "Terence Lee"]

    gem.add_dependency 'rest-client', '~> 1.6.0'
    gem.add_dependency 'happymapper', '>= 0.3.2'
    gem.add_dependency 'builder'
    gem.add_dependency 'nokogiri', '~> 1.6.2.1'

    gem.add_development_dependency 'rspec', '~> 2.14.1'
    gem.add_development_dependency 'bundler', '~> 1.0.12'
    gem.add_development_dependency 'jeweler', '~> 2.0.1'
    gem.add_development_dependency 'stale_fish', '~> 1.3.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

