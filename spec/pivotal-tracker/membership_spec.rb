require 'spec_helper'

describe PivotalTracker::Project do
  before do
    @project = PivotalTracker::Project.find(102622)
  end

  context ".all" do
    it "should return an array of memberships" do
      @project.memberships.all.should be_a(Array)
      @project.memberships.all.first.should be_a(PivotalTracker::Membership)
    end
  end

  context ".find" do
    it "should return the given membership" do
      @project.memberships.find(331822).should be_a(PivotalTracker::Membership)
    end
  end

  context ".create" do
    it "should return the created membership" do
      @project.memberships.create(:email => "jmischo@sittercity.com").should be_a(PivotalTracker::Membership)
    end

    context "on failure" do
      before do
        FakeWeb.register_uri(:post, "#{PivotalTracker::Client.api_url}/projects/#{@project.id}/memberships",
          :body => %{<?xml version="1.0" encoding="UTF-8"?>
             <errors>
               <error>error#1 message</error>
               <error>error#2 message</error>
             </errors>%},
           :status => "422")
      end

      it "should not raise an exception" do
        expect { @project.memberships.create }.to_not raise_error(Exception)
      end

      it "should report errors encountered" do
        story = @project.memberships.create :email => "jmischo@sittercity.com"
        story.errors.messages.should =~ ["error#1 message", "error#2 message"]
      end
    end
  end

  context ".new" do

    def membership_for(attrs)
      membership = @project.memberships.new(attrs)
      @membership = Crack::XML.parse(membership.send(:to_xml))['membership']
    end

    describe "attributes that are not sent to the tracker" do

      it "should include id" do
        membership_for(:id => 10)["id"].should be_nil
      end

    end

    describe "attributes that are sent to the tracker" do

      it "should include role" do
        membership_for(:role => "member")["role"].should == "member"
      end

      it "should include person => name" do
        membership_for(:name => "name")["person"]["name"].should == "name"
      end

      it "should include person => initials" do
        membership_for(:initials => "initials")["person"]["initials"].should == "initials"
      end

      it "should include person => email" do
        membership_for(:email => "email")["person"]["email"].should == "email"
      end

    end
  end
end
