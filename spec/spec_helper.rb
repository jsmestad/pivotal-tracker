Bundler.require(:default, :runtime, :test)
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
 
require 'pivotal-tracker'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  # config.include(Rack::Test::Methods)
end