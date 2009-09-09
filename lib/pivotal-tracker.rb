require 'restclient'
require 'happymapper'
require 'builder'
require 'cgi'


# initial definition, to avoid circular dependencies when declaring happymappings
class Story; end
class Iteration; end
class Project; end
class Note; end

require 'pivotal-tracker/extensions'
require 'pivotal-tracker/project'
require 'pivotal-tracker/story'
require 'pivotal-tracker/iteration'
require 'pivotal-tracker/note'
require 'pivotal-tracker/task'

class PivotalTracker
  def initialize(project_id, token, options = {})
    @project_id, @token = project_id, token

    @base_url = "http://www.pivotaltracker.com/services/v2" 
    @base_url.gsub! 'http', 'https'  if options[:use_ssl]
  end 

  def project
    response = project_resource.get
    Project.parse(response)
  end
  
  def stories
    response = stories_resource.get
    Story.parse(response)
  end

  def notes(id)
    response = story_resource(id)["/notes"].get
    Note.parse(response)
  end

  def tasks(id)
    response = story_resource(id)["/tasks"].get
    Task.parse(response)
  end

  def create_note(id, note)
    story_resource(id)["/notes"].post note.to_xml
  end

  def create_task(id, task)
    story_resource(id)["/tasks"].post task.to_xml
  end

  def find_task(story_id, task_id)
    response = story_resource(story_id)["/tasks/#{task_id}"].get
    Task.parse(response)
  end
  
  def update_task(story_id, task)
    task_id = task.id
    story_resource(id)["/tasks/#{task_id}"].put task.to_xml
  end

  def current_iteration
    response = iterations_resource("/current").get
    Iteration.parse(response).first
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
    Story.parse(response)
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

  def iterations_resource(specific_iteration = "")
    project_resource["/iterations#{specific_iteration}"]
  end

  def stories_resource
    project_resource['/stories']
  end

  def story_resource(story)
    stories_resource["/#{story.to_param}"]
  end

  def coerce_to_filter(object)
    case object
    when String
      object
    when Integer,NilClass
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
