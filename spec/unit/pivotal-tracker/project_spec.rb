require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe PivotalTracker::Project do
  context ".all" do
    before do
      @projects = PivotalTracker::Project.all  
    end
    
    it "should return an array of available projects" do
      @projects.should be_a(Array)
    end
    
    it "should be a project instance" do
      @projects.first.should be_a(PivotalTracker::Project)
    end
  end
end
