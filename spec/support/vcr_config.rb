require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :fakeweb
  c.debug_logger = File.open(File.join(Rails.root, 'log/vcr_debug.log'), 'w')
  c.default_cassette_options = { :record => :new_episodes }
  c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata!
end
