require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe PivotalTracker::Project do
  before do
    @project = PivotalTracker::Project.find(59022)
  end

  context ".all" do
    it "should return an array of memberships" do
      @project.memberships.all.should be_a(Array)
      @project.memberships.all.first.should be_a(PivotalTracker::Membership)
    end
  end

  context ".find" do
    it "should return the given membership" do
      @project.memberships.find(207328).should be_a(PivotalTracker::Membership)
    end
  end
end
