require 'pivotal-tracker'
require 'rspec'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

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

RSpec.configure do |config|
  # Allow focus on a specific test if specified
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before :suite do
    # Give StaleFish temporary file which is ignored by git
    org_stale_fish_config = File.join(File.dirname(__FILE__), 'fixtures', 'stale_fish.yml')
    tmp_stale_fish_config = File.join(File.dirname(__FILE__), 'fixtures', 'stale_fish-tmp.yml')
    FileUtils.copy_file org_stale_fish_config, tmp_stale_fish_config, remove_destination: true
    StaleFish.setup(tmp_stale_fish_config)

    StaleFish.update_stale
  end

  config.before :each do
    PivotalTracker::Client.clear_connections
  end
end
