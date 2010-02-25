require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe PivotalTracker::Task do
  before do
    @project = PivotalTracker::Project.find(59022)
    @story = @project.stories.all.first
  end

  context ".all" do
    it "should return an array of tasks" do
      @story.tasks.all.should be_a(Array)
      @story.tasks.all.first.should be_a(PivotalTracker::Task)
    end
  end

  context ".find" do
    it "should return a given task" do
      @story.tasks.find(179025).should be_a(PivotalTracker::Task)
    end
  end
end
