require "spec_helper"

describe PivotalTracker::Client do

  describe ".connection" do

    context "with no existing token" do

      before do
        PivotalTracker::Client.token = nil
      end

      it "raises a NoToken exception" do
        lambda { PivotalTracker::Client.connection }.should raise_error(PivotalTracker::Client::NoToken)
      end

      describe "after setting a new token" do

        before do
          PivotalTracker::Client.token = "anewtoken"
        end

        it "called to RestClient::Resource using the new token" do
          RestClient::Resource.should_receive(:new).
              with(PivotalTracker::Client.api_url, :headers => { 'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml' })

          PivotalTracker::Client.connection
        end

        it "returned the connection for the new token" do
          @resource = Object.new

          RestClient::Resource.should_receive(:new).
              with(PivotalTracker::Client.api_url, :headers => { 'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml' }).
              and_return(@resource)

          PivotalTracker::Client.connection.should == @resource

          # We need to clear the connections or it causes later spec failures
          PivotalTracker::Client.clear_connections
        end

      end

    end

    context "with an existing token" do

      before do
        PivotalTracker::Client.token = "abc123"
      end

      it "returned a RestClient::Resource using the token" do
        @resource = Object.new

        RestClient::Resource.should_receive(:new).
            with(PivotalTracker::Client.api_url, :headers => { 'X-TrackerToken' => "abc123", 'Content-Type' => 'application/xml' }).
            and_return(@resource)

        PivotalTracker::Client.connection.should == @resource
      end

      describe "after setting a new token" do

        before do
          PivotalTracker::Client.token = "anewtoken"
        end

        it "called to RestClient::Resource using the new token" do
          RestClient::Resource.should_receive(:new).
              with(PivotalTracker::Client.api_url, :headers => { 'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml' })

          PivotalTracker::Client.connection
        end

        it "returned the connection for the new token" do
          @resource = Object.new

          RestClient::Resource.should_receive(:new).
              with(PivotalTracker::Client.api_url, :headers => { 'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml' }).
              and_return(@resource)

          PivotalTracker::Client.connection.should == @resource
        end

      end

    end
  end

  describe ".tracker_host" do
    it "returns www.pivotaltracker.com by default" do
      PivotalTracker::Client.tracker_host.should == 'www.pivotaltracker.com'
    end
  end

  describe ".tracker_host=" do
    it "sets the tracker_host" do
      tracker_host_url = 'http://some_other_tracker_tracker_host_url'
      PivotalTracker::Client.tracker_host = tracker_host_url
      PivotalTracker::Client.tracker_host.should == tracker_host_url
      PivotalTracker::Client.tracker_host = nil
    end
  end

  describe "#api_ssl_url" do
    context "when not passed a username and password" do
      before do
        PivotalTracker::Client.tracker_host = nil
        PivotalTracker::Client.use_ssl      = true
      end
      it "returns https://www.pivotaltracker.com/services/v3" do
        PivotalTracker::Client.api_ssl_url.should == 'https://www.pivotaltracker.com/services/v3'
      end
    end
    context "when passed a username and password" do
      before do
        PivotalTracker::Client.tracker_host = nil
        PivotalTracker::Client.use_ssl      = false
      end
      it "returns https://USER:PASSWORD@www.pivotaltracker.com/services/v3" do
        PivotalTracker::Client.api_ssl_url('USER', 'PASSWORD').should == 'https://USER:PASSWORD@www.pivotaltracker.com/services/v3'
      end
    end
  end

  describe "#api_url" do
    context "when not passed a username and password" do
      before do
        PivotalTracker::Client.tracker_host = nil
        PivotalTracker::Client.use_ssl      = true
      end
      it "returns https://www.pivotaltracker.com/services/v3" do
        PivotalTracker::Client.api_ssl_url.should == 'https://www.pivotaltracker.com/services/v3'
      end
    end
    context "when passed a username and password" do
      before do
        PivotalTracker::Client.tracker_host = nil
        PivotalTracker::Client.use_ssl      = false
      end
      it "returns https://www.pivotaltracker.com/services/v3" do
        PivotalTracker::Client.api_ssl_url('user', 'password').should == 'https://user:password@www.pivotaltracker.com/services/v3'
      end
    end
  end

end
