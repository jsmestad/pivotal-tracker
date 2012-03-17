require 'bundler'

Bundler.require(:default, :runtime, :test)
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pivotal-tracker'
require 'rspec'
require 'rspec/autorun'

PROJECT_ID = ENV['PROJECT_ID'] || "102622"
TOKEN = '8358666c5a593a3c82cda728c8a62b63'

PivotalTracker::Client.token = TOKEN

# tm: hack StaleFish to prevent it from accessing real API which slows down the test.
#   Fixtures should be upated manually.
module StaleFish
  class Fixture
    def is_stale?
      false
    end
  end
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

StaleFish.setup(File.join(File.dirname(__FILE__), 'fixtures', 'stale_fish.yml'))

RSpec.configure do |config|
  # config.include(Rack::Test::Methods)

  config.before :suite do
    StaleFish.update_stale
  end

end
