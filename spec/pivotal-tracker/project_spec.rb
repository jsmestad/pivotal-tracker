require 'spec_helper'

describe PivotalTracker::Project do
  context ".all" do
    before do
      PivotalTracker::Client.token = TOKEN
      @projects = PivotalTracker::Project.all
    end

    it "should return an array of available projects" do
      @projects.should be_a(Array)
    end

    it "should be a project instance" do
      @projects.first.should be_a(PivotalTracker::Project)
    end        
  end

  context ".find" do
    before do
      @project = PivotalTracker::Project.find(102622)
    end

    it "should be an instance of Project" do
      @project.should be_a(PivotalTracker::Project)
    end

    it "should have a use_https attribute" do
      @project.respond_to?(:use_https).should be_true
    end

    it "should have false for use_https" do
      @project.use_https.should be_false
    end
    
    it "should have first_iteration_start_time attribute" do
      @project.respond_to?(:first_iteration_start_time).should be_true
    end
     
    it "should have current_iteration_number attribute" do  
      @project.respond_to?(:current_iteration_number).should be_true
    end
  end

  context ".stories" do
    before do
      @project = PivotalTracker::Project.find(102622)
    end

    it "should have a stories association" do
      @project.respond_to?(:stories).should be_true
    end
  end

  context ".memberships" do
    before do
      @project = PivotalTracker::Project.find(102622)
    end

    it "should have a memberships association" do
      @project.respond_to?(:memberships).should be_true
    end
  end

  context ".create" do
    before do
      @project = PivotalTracker::Project.new(:name => 'Pivotal Tracker API Gem')
    end

    it "should return the created project" do
      @project.create
      @project.should be_a(PivotalTracker::Project)
      @project.name.should == 'Pivotal Tracker API Gem'
    end

    context "on failure" do
      before do
        FakeWeb.register_uri(:post, "#{PivotalTracker::Client.api_url}/projects",
                             :body   => %{<?xml version="1.0" encoding="UTF-8"?>
             <errors>
               <error>error#1 message</error>
               <error>error#2 message</error>
             </errors>%},
                             :status => "422")
      end

      it "should not raise an exception" do
        expect { @project.create }.to_not raise_error(Exception)
      end

      it "should report errors encountered" do
        @project.create
        @project.errors.messages.should =~ ["error#1 message", "error#2 message"]
      end
    end
  end

  context ".deliver_all_finished" do
    before do
      @project = PivotalTracker::Project.find(102622)
    end

    it "should deliver and return stories that were delivered" do
      stories = @project.deliver_all_finished
      stories.should be_a(Array)
      stories.first.should be_a(PivotalTracker::Story)
      stories.count.should == 1
    end

    context "with no stories set to finished" do
      before do
        FakeWeb.register_uri(:put, "#{PivotalTracker::Client.api_url}/projects/102622/stories/deliver_all_finished", 
                             :body => %{<?xml version="1.0" encoding="UTF-8"?>
<stories type="array"/>}, :status => "200")
      end
      
      it "should return empty" do
        @project.deliver_all_finished.count.should == 0
      end
    end
  end


end
