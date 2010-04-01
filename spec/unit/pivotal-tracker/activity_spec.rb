require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe PivotalTracker::Activity do

  context "without a specified project" do
    it "should return an array of activities" do
      PivotalTracker::Activity.all.should be_a(Array)
      PivotalTracker::Activity.all.first.should be_a(PivotalTracker::Activity)
    end
  end

  context "with a specified project" do
    before do
      @project = PivotalTracker::Project.find(PROJECT_ID)
    end

    it "should return an array of activities" do
      @project.activities.all.should be_a(Array)
      @project.activities.all.first.should be_a(PivotalTracker::Activity)
    end
  end

end
