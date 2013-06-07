require 'bundler'
require 'fileutils'

Bundler.require(:default, :runtime, :test)
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pivotal-tracker'
require 'rspec'
require 'rspec/autorun'

PROJECT_ID = ENV['PROJECT_ID'] || 102622
PAGE_PROJECT_ID = ENV['PAGE_PROJECT_ID'] || 10606
TOKEN = '8358666c5a593a3c82cda728c8a62b63'

PivotalTracker::Client.token = TOKEN

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}


RSpec.configure do |config|
  # setup VCR to record all external requests with a single casette
  # works for everything but features
  config.around :each, :type => proc{ |value| value != :feature } do |example|
    VCR.use_cassette("default_vcr_cassette") { example.call }
  end
  
  config.before :each do
    PivotalTracker::Client.clear_connections
  end
end
