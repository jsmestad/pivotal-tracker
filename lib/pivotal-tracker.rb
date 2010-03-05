require 'cgi'
require 'rest_client'
require 'happymapper'
require 'nokogiri'


require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'extensions')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'proxy')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'client')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'project')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'story')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'task')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'membership')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'activity')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'iteration')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'note')

module PivotalTracker

  # define error types
  class ProjectNotSpecified < StandardError; end

  def self.encode_options(options)
    return nil if !options.is_a?(Hash) || options.empty?

    options_string = []
    options_string << "limit=#{options.delete(:limit)}" if options[:limit]
    options_string << "offset=#{options.delete(:offset)}" if options[:offset]

    filters = []
    options.each do |key, value|
      values = value.is_a?(Array) ? value.map {|x| CGI.escape(x) }.join(',') : CGI.escape(value)
      filters << "#{key}%3A#{values}" # %3A => :
    end
    options_string << "filter=#{filters.join('%20')}" unless filters.empty? # %20 => &amp;

    return "?#{options_string.join('&')}"
  end

end
