module PivotalTracker
  class Story
    attr_accessor :project

    def initialize(project_id)
      self.project = project_id
    end

    def all
      Client.connection["/projects/#{project}/stories"].get
    end

  end
end
