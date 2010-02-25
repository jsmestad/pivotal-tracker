module PivotalTracker
  class Task
    include HappyMapper

    class << self
      def all(story, options={})
        parse(Client.connection["/projects/#{story.project_id}/stories/#{story.id}/tasks"].get)
      end
    end

    element :id, Integer
    element :description, String
    element :position, Integer
    element :complete, Boolean
    element :created_at, DateTime

  end
end
