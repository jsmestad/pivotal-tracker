require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe PivotalTracker::Attachment do

  before do
    @project = PivotalTracker::Project.find(102622)
    @story = @project.stories.find(4460598)
  end

  context "always" do
    it "should return an integer id" do
      @story.attachments.first.id.should be_a(Integer)
    end

    it "should return a string for url" do
      @story.attachments.first.url.should be_a(String)
    end

    it "should return a string for filename" do
      @story.attachments.first.filename.should be_a(String)
    end

    it "should return a string for uploaded_by" do
      @story.attachments.first.uploaded_by.should be_a(String)
    end

    it "should return a datetime for uploaded_at" do
      @story.attachments.first.uploaded_at.should be_a(DateTime)
    end
  end

  context "without description"do
    it "should have a blank string for the description" do
      @story.attachments.first.description.should be_a(String)
      @story.attachments.first.description.should be_blank
    end
  end

  context "with description"do
    it "should have a non-blank string for the description" do
      @story.attachments.first.description.should be_a(String)
      @story.attachments.last.description.should_not be_blank
    end
  end

end
