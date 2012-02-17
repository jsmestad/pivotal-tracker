require "spec_helper"
require 'ruby-debug'

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
          RestClient::Resource.should_receive(:new).with("http://www.pivotaltracker.com/services/v3", :headers => {'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml'})

          PivotalTracker::Client.connection
        end

        it "returned the connection for the new token" do
          @resource = Object.new

          RestClient::Resource.should_receive(:new).
          with("http://www.pivotaltracker.com/services/v3", :headers => {'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml'}).
          and_return(@resource)

          PivotalTracker::Client.connection.should == @resource
        end

      end

    end

    context "with an existing token" do

      before do
        PivotalTracker::Client.clear_connections
        PivotalTracker::Client.token = "abc123"
      end

      it "should fetch a new token when logging in" do
        NEW_TOKEN = "new_token"

        response_body = Nokogiri::XML::Builder.new do |root|
          root.guid NEW_TOKEN
        end

        FakeWeb.register_uri :post,
          'https://www.pivotaltracker.com/services/v3/tokens/active',
          body: response_body.to_xml

        PivotalTracker::Client.token("user", "password").should == NEW_TOKEN
      end

      it "should use different connection for new token" do
        connection1 = PivotalTracker::Client.connection
        connection1.should_not be_nil

        PivotalTracker::Client.token = "other_token"
        connection2 = PivotalTracker::Client.connection
        connection2.should_not be_nil

        connection2.should_not == connection1
      end


      it "returned a RestClient::Resource using the token" do
        @resource = Object.new

        RestClient::Resource.should_receive(:new).
          with("http://www.pivotaltracker.com/services/v3", :headers => {'X-TrackerToken' => "abc123", 'Content-Type' => 'application/xml'}).
          and_return(@resource)

        PivotalTracker::Client.connection.should == @resource
      end

      describe "after setting a new token" do

        before do
          PivotalTracker::Client.token = "anewtoken"
        end

        it "called to RestClient::Resource using the new token" do
          RestClient::Resource.should_receive(:new).with("http://www.pivotaltracker.com/services/v3", :headers => {'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml'})

          PivotalTracker::Client.connection
        end

        it "returned the connection for the new token" do
          @resource = Object.new

          url = "http://www.pivotaltracker.com/services/v3"
          @resource.stub(:url, url)

          RestClient::Resource.should_receive(:new).
            with(url, :headers => {'X-TrackerToken' => "anewtoken", 'Content-Type' => 'application/xml'}).
            and_return(@resource)

          PivotalTracker::Client.connection.should == @resource
        end

      end

    end
  end

end