require 'cgi'
require 'rest_client'
require 'happymapper'
require 'nokogiri'


require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'extensions')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'proxy')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'client')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'project')
require File.join(File.dirname(__FILE__), 'pivotal-tracker', 'attachment')
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
    options_strings = []
    # remove options which are not filters, and encode them as such
    [:limit, :offset].each do |o|
      options_strings << "#{CGI.escape(o.to_s)}=#{CGI.escape(options.delete(o))}" if options[o]
    end
    # assume remaining key-value pairs describe filters, and encode them as such.
    filters_string = options.map do |key, value|
      [value].flatten.map {|v| "#{CGI.escape(key.to_s)}%3A#{CGI.escape(v)}"}.join('&filter=')
    end
    options_strings << "filter=#{filters_string}" unless filters_string.empty?
    return "?#{options_strings.join('&')}"
  end

end
