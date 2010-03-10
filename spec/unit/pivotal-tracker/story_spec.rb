require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe PivotalTracker::Story do
  before do
    @project = PivotalTracker::Project.find(59022)
  end

  context ".all" do
    it "should return all stories" do
      @project.stories.all.should be_a(Array)
      @project.stories.all.first.should be_a(PivotalTracker::Story)
    end
  end

  context ".find" do
    it "should return the matching story" do
      @project.stories.find(2524690).should be_a(PivotalTracker::Story)
    end
  end

  context ".create" do
    it "should return the created story" do
      @project.stories.create(:name => 'Create Stuff').should be_a(PivotalTracker::Story)
    end
  end

end
