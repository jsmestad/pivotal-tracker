module PivotalTracker
  class Client

    class << self
      attr_writer :use_ssl, :token
    end

    def self.use_ssl
      @use_ssl || false
    end

    def self.token(username, password, method='post')
      response = if method == 'post'
        RestClient.post 'https://www.pivotaltracker.com/services/v3/tokens/active', :username => username, :password => password
      else
        RestClient.get "https://#{username}:#{password}@www.pivotaltracker.com/services/v3/tokens/active"
      end
      @token ||= Nokogiri::XML(response).search('guid').inner_html
    end

    # TODO: document with YARD
    # this is your connection for the entire module
    def self.connection(options={})
      @connection ||= RestClient::Resource.new("#{protocol}://www.pivotaltracker.com/services/v3", :headers => {'X-TrackerToken' => @token, 'Content-Type' => 'application/xml'})
    end

    protected
    def self.protocol
      use_ssl ? 'https' : 'http'
    end
  end
end
