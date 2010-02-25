module PivotalTracker
  class Note
    include HappyMapper

    class << self
#      def all(story, options={})
#        parse(Client.connection["/projects/#{project_id}/stories/#{story_id}/notes"].get)
#      end
    end

    element :id, Integer
    element :text, String
    element :author, String
    element :noted_at, DateTime
    # has_one :story, Story
  end
end
