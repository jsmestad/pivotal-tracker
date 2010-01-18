require File.join(File.dirname(__FILE__), 'vendor', 'gems', 'environment')
Bundler.require_env
require 'rake'
require 'bundler'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "pivotal-tracker"
    gem.summary = %Q{Ruby wrapper for the Pivotal Tracker API}
    gem.email = "justin.smestad@gmail.com"
    gem.homepage = "http://github.com/jsmestad/pivotal-tracker"
    gem.authors = ["Justin Smestad", "Josh Nichols", "Terence Lee"]
    
    manifest = Bundler::Environment.new(File.dirname(__FILE__) + '/Gemfile')
    manifest.dependencies.each do |d|
      next if d.only
      gem.add_dependency(d.name, d.version)
    end
    
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end

