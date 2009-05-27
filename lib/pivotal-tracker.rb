require 'rubygems'
require 'hpricot'
require 'net/http'
require 'restclient'
require 'happymapper'
require 'uri'
require 'cgi'
require 'builder'

##
# Pivotal Tracker API Ruby Wrapper
# November 11, 2008
# Justin Smestad
# http://www.evalcode.com
##

class Project
  include HappyMapper
  element :name, String
  element :iteration_length, String
  element :week_start_day, String
  element :point_scale, String
end

class Story
  include HappyMapper
  element :id, Integer
  element :type, String
  element :name, String

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  def to_xml(options = {})
    builder = Builder::XmlMarkup.new(options)
    builder.story do |story|
      story.id   id.to_s   if id
      story.type type.to_s if type
      story.name name.to_s if name
    end
  end

  def to_param
    id.to_s
  end
end

class String
  def to_param
    self
  end
end

class Integer
  def to_param
    to_s
  end
end

class Tracker
  def initialize(project_id = '2893', token = '25a6a078f67d9210d2fba91f8c484e7b')
    @project_id, @token = project_id, token
  end
  
  def project
    response = project_resource.get 'Token' => @token
    Project.parse(response).first
  end
  
  def stories
    response = project_resource['stories'].get 'Token' => @token
    Story.parse(response)
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

  def project_resource
    RestClient::Resource.new "http://www.pivotaltracker.com/services/v1/projects/#{@project_id}"
  end

  def stories_resource
    project_resource['stories']
  end

  def story_resource(story)
    stories_resource["/#{story.to_param}"]
  end
end
