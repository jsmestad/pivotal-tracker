require 'spec_helper'

describe PivotalTracker::Task do
  before do
    PivotalTracker::Client.token = TOKEN
    @project = PivotalTracker::Project.find(PROJECT_ID)
    @story = @project.stories.find(ATTACHMENT_STORY)
  end

  context ".all" do
    it "should return an array of tasks" do
      @story.tasks.all.should be_a(Array)
      @story.tasks.all.first.should be_a(PivotalTracker::Task)
    end
  end

  context ".find" do
    it "should return a given task" do
      @story.tasks.find(TASK_ID).should be_a(PivotalTracker::Task)
    end
  end

  context ".create" do
    it "should return the created task" do
      @story.tasks.create(:description => 'Test task')
    end
  end

  context '.update' do
    it "should return the updated task" do
      @story.tasks.find(TASK_ID).update(:description => 'Test task').description.should == 'Test task'
    end
  end
end
