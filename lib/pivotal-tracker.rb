require 'rest_client'
# require 'happymapper'
require 'builder'
require 'cgi'

require 'pivotal-tracker/client'
require 'pivotal-tracker/project'
require 'pivotal-tracker/story'

module PivotalTracker

  # define error types
  class ProjectNotSpecified < StandardError; end

end
