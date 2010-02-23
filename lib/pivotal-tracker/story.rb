module PivotalTracker
  class Story
    include HappyMapper

    class << self
      def all(project, options={})

        params = PivotalTracker.encode_options(options)
        p params.inspect
        parse(Client.connection["/projects/#{project.id}/stories#{params}"].get)
      end
    end

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

  end
end
