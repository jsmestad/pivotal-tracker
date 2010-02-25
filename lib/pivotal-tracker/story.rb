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

    def tasks
      @tasks ||= Proxy.new(self, Task)
    end

  end
end
