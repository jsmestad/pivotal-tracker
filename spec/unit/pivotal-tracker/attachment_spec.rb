require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe PivotalTracker::Attachment do

  before do
    @project = PivotalTracker::Project.find(102622)
    @story = @project.stories.find(4460598)
  end

  context ".all" do
    it "should return an array of attachments" do
      @story.attachments.should be_a(Array)
      @story.attachments.first.should be_a(PivotalTracker::Attachment)
    end
  end

end
