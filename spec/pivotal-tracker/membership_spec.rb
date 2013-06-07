require 'spec_helper'

describe PivotalTracker::Project do
  before do
    PivotalTracker::Client.token = TOKEN
    @project = PivotalTracker::Project.find(PROJECT_ID)
  end

  context ".all" do
    it "should return an array of memberships" do
      @project.memberships.all.should be_a(Array)
      @project.memberships.all.first.should be_a(PivotalTracker::Membership)
    end
  end

  context ".find" do
    it "should return the given membership" do
      @project.memberships.find(MEMBER).should be_a(PivotalTracker::Membership)
    end
  end
end
