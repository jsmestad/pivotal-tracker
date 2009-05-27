require 'restclient'
require 'happymapper'
require 'builder'


require 'pivotal-tracker/extensions'

# initial definition, to avoid circular dependencies when declaring happymappings
class Story; end
class Iteration; end
class Project; end

require 'pivotal-tracker/project'
require 'pivotal-tracker/story'
require 'pivotal-tracker/iteration'

class PivotalTracker
  def initialize(project_id, token)
    @project_id, @token = project_id, token
  end
  
  def project
    response = project_resource.get 'Token' => @token
    Project.parse(response).first
  end
  
  def stories
    response = stories_resource.get 'Token' => @token
    Story.parse(response)
  end

  def iterations
    response = iterations_resource.get 'Token' => @token
    Iteration.parse(response)
  end
  
  # would ideally like to pass a size, aka :all to limit search
  def find(filters = {})
    unless filters.empty?
      filter_string = "?filter=" 
      filters.each do |key, value|
        filter_string << CGI::escape("#{key}:\"#{value}\"")
      end
    else
      filter_string = ""
    end

    response = stories_resource[filter_string].get
    
    Story.parse(response)
  end
  
  def find_story(id)
    story_resource(id).get 'Token' => @token, 'Content-Type' => 'application/xml'

    Story.parse(response).first
  end
  
  def create_story(story)
    stories_resource.post story.to_xml, 'Token' => @token, 'Content-Type' => 'application/xml'
  end
  
  def update_story(story)
    story_resource(story).put story.to_xml, 'Token' => @token, 'Content-Type' => 'application/xml'
  end
  
  def delete_story(story)
    story_resource(story).delete 'Token' => @token
  end

  protected

  def projects_resource
    RestClient::Resource.new "http://www.pivotaltracker.com/services/v1/projects"
  end

  def project_resource(project = @project_id)
    projects_resource["/#{@project_id}"]
  end

  def iterations_resource
    project_resource["/iterations"]
  end

  def stories_resource
    project_resource['/stories']
  end

  def story_resource(story)
    stories_resource["/#{story.to_param}"]
  end
end
