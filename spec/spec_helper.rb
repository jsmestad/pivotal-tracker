$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

project_root = File.expand_path(File.dirname(__FILE__))
require File.join(project_root, '..', 'vendor', 'gems', 'environment')
Bundler.require_env(:test)
 
require 'pivotal-tracker'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  # config.include(Rack::Test::Methods)
end