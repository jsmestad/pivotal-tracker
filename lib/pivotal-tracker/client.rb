module PivotalTracker
  class Client

    class << self
      attr_writer :use_ssl
    end

    def self.use_ssl
      @use_ssl || false
    end

    def self.token(username, password, method='post')
      response = if method == 'post'
        RestClient.post 'https://www.pivotaltracker.com/services/tokens/active', :username => username, :password => password
      else
        RestClient.get "https://#{username}:#{password}@www.pivotaltracker.com/services/tokens/active"
      end
      @token ||= Nokogiri::XML(response).search('guid').inner_html
    end

    # TODO: document with YARD
    # this is your connection for the entire module
    def self.connection(options={})
      if use_ssl
        @secure_connection ||= RestClient::Resource.new('https://www.pivotaltracker.com/services/v2', :headers => {'X-TrackerToken' => @token, 'Content-Type' => 'application/xml'})
      else
        @connection ||= RestClient::Resource.new('http://www.pivotaltracker.com/services/v2', :headers => {'X-TrackerToken' => @token, 'Content-Type' => 'application/xml'})
      end
    end

  end
end
