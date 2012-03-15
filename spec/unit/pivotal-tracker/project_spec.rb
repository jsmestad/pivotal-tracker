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
    
    it "should not have nil in field first_iteration_start_time" do
      @projects.each do |pt|
         pt.first_iteration_start_time.should_not be_nil
      end 
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
        FakeWeb.register_uri(:post, "http://www.pivotaltracker.com/services/v3/projects",
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

end
