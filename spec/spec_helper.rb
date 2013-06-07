require 'bundler'
require 'fileutils'

Bundler.require(:default, :runtime, :test)
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pivotal-tracker'
require 'rspec'
require 'rspec/autorun'

PROJECT_ID = ENV['PROJECT_ID'] || 833075
PAGE_PROJECT_ID = ENV['PAGE_PROJECT_ID'] || 10606
ATTACHMENT_STORY = 51345231
UPLOAD_STORY = 51345285
MEMBER = 3129903
TASK_ID = 15030357
TOKEN = 'c894469f31a343c1f94017752a2a496f'

PivotalTracker::Client.token = TOKEN

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}


RSpec.configure do |config|
  # setup VCR to record all external requests with a single casette
  # works for everything but features
  config.around :each do |example|
    VCR.use_cassette("default_vcr_cassette") { example.call }
  end

  config.before :each do
    PivotalTracker::Client.clear_connections
  end
end
