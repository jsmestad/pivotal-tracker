require 'restclient'
require 'happymapper'
require 'builder'
require 'cgi'


# initial definition, to avoid circular dependencies when declaring happymappings
class Story; end
class Iteration; end
class Project; end

require 'pivotal-tracker/extensions'
require 'pivotal-tracker/project'
require 'pivotal-tracker/story'
require 'pivotal-tracker/iteration'

class PivotalTracker
  def initialize(project_id, token, options = {})
    @project_id, @token = project_id, token

    @base_url = "http://www.pivotaltracker.com/services/v2" 
    @base_url.gsub! 'http', 'https'  if options[:use_ssl]
  end
  
  def project
    response = project_resource.get
    Project.parse(response).first
  end
  
  def stories
    response = stories_resource.get
    Story.parse(response)
  end

  def iterations
    response = iterations_resource.get
    Iteration.parse(response)
  end
  
  def find(*filters)
    filter_query = CGI::escape coerce_to_filter(filters)
    response = stories_resource["?filter=#{filter_query}"].get
    Story.parse(response)
  end
  
  def find_story(id)
    response = story_resource(id).get
    Story.parse(response).first
  end
  
  def create_story(story)
    stories_resource.post story.to_xml
  end
  
  def update_story(story)
    story_resource(story).put story.to_xml
  end
  
  def delete_story(story)
    story_resource(story).delete
  end

  def deliver_all_finished_stories
    response = stories_resource['/deliver_all_finished'].put ''
    Story.parse(response)
  end

  protected

  def projects_resource
    RestClient::Resource.new "#{@base_url}/projects",
                             :headers => {
                               'X-TrackerToken' => @token,
                               'Content-Type' => 'application/xml'
                             }
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

  def coerce_to_filter(object)
    case object
    when String, Integer,NilClass
      object.to_s.inspect
    when Hash
      object.collect do |key, value|
        "#{key}:#{coerce_to_filter(value)}"
      end.join(' ')
    when Array
      object.collect do |each|
        coerce_to_filter(each)
      end.join(' ')
    end
  end
end
