require 'rubygems'
require 'hpricot'
require 'net/http'
require 'restclient'
require 'uri'
require 'cgi'

##
# Pivotal Tracker API Ruby Wrapper
# November 11, 2008
# Justin Smestad
# http://www.evalcode.com
##

class Tracker
  def initialize(project_id = '2893', token = '25a6a078f67d9210d2fba91f8c484e7b')
    @project_id, @token = project_id, token
  end

  def project_resource
    @project_resource ||= begin
                            RestClient::Resource.new "http://www.pivotaltracker.com/services/v1/projects/#{@project_id}"
                          end
  end
  
  def project
    response = project_resource.get 'Token' => @token

    doc = Hpricot(response.body).at('project')

    @project = {
      :name             => doc.at('name').innerHTML,
      :iteration_length => doc.at('iteration_length').innerHTML,
      :week_start_day   => doc.at('week_start_day').innerHTML,
      :point_scale      => doc.at('point_scale').innerHTML
    }
  end
  
  def stories
    response = project_resource['stories'].get 'Token' => @token

    doc = Hpricot(response.body)
    
    @stories = []
    
    doc.search('stories > story').each do |story|
      @stories << {
        :id => story.at('id').innerHTML.to_i,
        :type => story.at('story_type').innerHTML,
        :name => story.at('name').innerHTML
      }
    end
    return @stories
  end
  
  # would ideally like to pass a size, aka :all to limit search
  def find(filters = {})
    uri = "http://www.pivotaltracker.com/services/v1/projects/#{@project_id}/stories"
    unless filters.empty?
      uri << "?filter=" 
      filters.each do |key, value|
        uri << CGI::escape("#{key}:\"#{value}\"")
      end
    end
    
    resource_uri = URI.parse(uri)
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      http.get(resource_uri.path, {'Token' => @token})
    end

    doc = Hpricot(response.body)
    
    @stories = []
    
    doc.search('stories > story').each do |story|
      @stories << {
        :id => story.at('id').innerHTML.to_i,
        :type => story.at('story_type').innerHTML,
        :name => story.at('name').innerHTML
      }
    end
    return @stories
  end
  
  def find_story(id)
    project_resource["/stories/#{id}"].get 'Token' => @token, 'Content-Type' => 'application/xml'

    resource_uri = URI.parse("http://www.pivotaltracker.com/services/v1/projects/#{@project_id}/stories/#{id}")
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      http.get(resource_uri.path, {})
    end
    
    doc = Hpricot(response.body).at('story')
    
    @story = {
      :id => doc.at('id').innerHTML.to_i,
      :type => doc.at('story_type').innerHTML,
      :name => doc.at('name').innerHTML
    }
  end
  
  def create_story(story)
    story_xml = build_story_xml(story)
    resource_uri = URI.parse("http://www.pivotaltracker.com/services/v1/projects/#{@project_id}/stories")
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      http.post(resource_uri.path, story_xml, {'Token' => @token, 'Content-Type' => 'application/xml'})
    end
  end
  
  def update_story(story)
    story_xml = build_story_xml(story)
    resource_uri = URI.parse("http://www.pivotaltracker.com/services/v1/projects/#{@project_id}/stories/#{story[:id]}")
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      http.put(resource_uri.path, story_xml, {'Token' => @token, 'Content-Type' => 'application/xml'})
    end
  end
  
  def delete_story(story_id)
    resource_uri = URI.parse("http://www.pivotaltracker.com/services/v1/projects/#{@project_id}/stories/#{story_id}")
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      http.delete(resource_uri.path, {'Token' => @token})
    end
  end
  
  private
    
    def build_story_xml(story)
      story_xml = "<story>"
      story.each do |key, value|
        story_xml << "<#{key}>#{value.to_s}</#{key}>"
      end
      story_xml << "</story>"
    end
end
