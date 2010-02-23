module StaleFishFixtures
  class << self
    
    def update_projects_fixture
      connection["/projects"].get
    end
    
    def update_project_fixture
      connection["/projects/59022"].get
    end
    
    protected
    
      def connection
        @connection ||= RestClient::Resource.new('http://www.pivotaltracker.com/services/v3', :headers => {'X-TrackerToken' => TOKEN, 'Content-Type' => 'application/xml'})
      end
      
  end
end