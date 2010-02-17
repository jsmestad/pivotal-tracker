Bundler.require(:default, :runtime, :test)
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pivotal-tracker'
require 'spec'
require 'spec/autorun'
require 'stale_fish'

PROJECT_ID = ENV['PROJECT_ID'] || "59022"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

StaleFish::Utility.config_path = File.join(File.dirname(__FILE__) + '/stale_fish.yml')

Spec::Runner.configure do |config|
  # config.include(Rack::Test::Methods)
  config.before do
    StaleFish.update_stale
  end

end
