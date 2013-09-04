require 'bundler'
require 'fileutils'

Bundler.require(:default, :runtime, :test)
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pivotal-tracker'
require 'rspec'
require 'rspec/autorun'

PROJECT_ID = ENV['PROJECT_ID'] || 102622
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


RSpec.configure do |config|
  # Allow focus on a specific test if specified
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  # Give StaleFish temporary file which is ignored by git
  org_stale_fish_config = File.join(File.dirname(__FILE__), 'fixtures', 'stale_fish.yml')
  tmp_stale_fish_config = File.join(File.dirname(__FILE__), 'fixtures', 'stale_fish-tmp.yml')
  FileUtils.copy_file org_stale_fish_config, tmp_stale_fish_config, :remove_destination => true
  StaleFish.setup(tmp_stale_fish_config)

  config.before :suite do
    StaleFish.update_stale
  end

  config.before :each do
    PivotalTracker::Client.clear_connections
  end
end
