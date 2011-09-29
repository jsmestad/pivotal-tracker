module PivotalTracker
  class Client

    class NoToken < StandardError; end

    class << self
      attr_writer :use_ssl, :token

      def use_ssl
        @use_ssl || false
      end

      def token(username, password, method='post')
        return @token if @token
        response = if method == 'post'
          RestClient.post 'https://www.pivotaltracker.com/services/v3/tokens/active', :username => username, :password => password
        else
          RestClient.get "https://#{username}:#{password}@www.pivotaltracker.com/services/v3/tokens/active"
        end
        @token= Nokogiri::XML(response.body).search('guid').inner_html
      end

      # this is your connection for the entire module
      def connection(options={})
        raise NoToken if @token.to_s.empty?

        @connections ||= {}

        cached_connection? && !protocol_changed? ? cached_connection : new_connection
      end

      protected

        def protocol
          use_ssl ? 'https' : 'http'
        end

        def cached_connection?
          !@connections[@token].nil?
        end

        def cached_connection
          @connections[@token]
        end

        def new_connection
          @connections[@token] = RestClient::Resource.new("#{protocol}://www.pivotaltracker.com/services/v3", :headers => {'X-TrackerToken' => @token, 'Content-Type' => 'application/xml'})
        end

        def protocol_changed?
          cached_connection? ? (cached_connection_protocol != protocol) : false
        end

        def cached_connection_protocol
          cached_connection.url.match(/^(.*):\/\//).captures.first
        end
    end

  end
end
