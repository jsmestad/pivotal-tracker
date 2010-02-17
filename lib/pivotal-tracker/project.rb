module PivotalTracker
  class Project

    class << self
      def all
        # /projects
        # Parse each and create new project array
        # response.each {|x| projects << parse(x) }
        #parse(connection['/projects'].get)
        Client.connection['/projects'].get
      end

      def find(id)
        # http://www.pivotaltracker.com/services/v2/projects/#{id}
        # parse response
        #parse(connection['/projects/#{id}'])
        Client.connection["/projects/#{id}"].get
      end
    end

    attr_accessor :stories

    def initialize
      self.stories ||= []
    end

  end
end
