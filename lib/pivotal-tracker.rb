require 'rest_client'
require 'happymapper'

require 'pivotal-tracker/proxy'
require 'pivotal-tracker/client'
require 'pivotal-tracker/project'
require 'pivotal-tracker/story'
require 'pivotal-tracker/membership'

module PivotalTracker

  # define error types
  class ProjectNotSpecified < StandardError; end

end
