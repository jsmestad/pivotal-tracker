module PivotalTracker
  class Story
    include HappyMapper

    class << self
      def all(project, options={})
        params = PivotalTracker.encode_options(options)
        stories = parse(Client.connection["/projects/#{project.id}/stories#{params}"].get)
        stories.each { |s| s.project_id = project.id }
        return stories
      end
    end

    attr_accessor :project_id

    element :id, Integer
    element :story_type, String
    element :url, String
    element :estimate, Integer
    # possible states: unscheduled, unstarted, started, finished, accepted, rejected
    element :current_state, String
    element :name, String
    element :requested_by, String
    element :owned_by, String
    element :created_at, DateTime
    element :accepted_at, DateTime
    element :labels, String
    element :description, String
    element :jira_id, Integer
    element :jira_url, String

    def initialize(project=nil, attributes={})
      self.project_id = project.is_a?(Integer) ? project : project.id

      attributes.each do |key, value|
        self.send("#{key}=", value.is_a?(Array) ? values.join(',') : value )
      end
    end

    def create
      return false if project_id.nil?
      response = Client.connection["/projects/#{project_id}/stories"].post "#{self.to_xml}", :content_type => 'application/xml'
      doc = Nokogiri::XML(response.body)
      @id = doc.search('id').inner_html
      self.url = doc.search('url').inner_html
      return true
    end

    def tasks
      @tasks ||= Proxy.new(self, Task)
    end

    protected

      def to_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.story {
            xml.name "#{name}"
            xml.story_type "#{story_type}"
            xml.estimate "#{estimate}"
            xml.current_state "#{current_state}"
            xml.requested_by "#{requested_by}"
            xml.owned_by "#{owned_by}"
            xml.labels "#{labels}"
            xml.description "#{description}"
            # xml.jira_id "#{jira_id}"
            # xml.jira_url "#{jira_url}"
          }
        end
        return builder.to_xml
      end
  end
end
