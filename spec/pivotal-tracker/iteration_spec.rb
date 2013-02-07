require 'spec_helper'

describe PivotalTracker::Iteration do
  before do
    PivotalTracker::Client.token = TOKEN
    @project = PivotalTracker::Project.find(PROJECT_ID)
  end

  describe ".all" do
    before do
      @iterations = PivotalTracker::Iteration.all(@project)
    end

    it "should return an array of Iterations for the given Project" do
      @iterations.should be_a(Array)
      @iterations.first.should be_a(PivotalTracker::Iteration)
    end
  end

  describe ".current" do
    before do
      @iteration = PivotalTracker::Iteration.current(@project)
    end

    it "should return a single Iteration" do
      @iteration.should be_a(PivotalTracker::Iteration)
    end
  end

  describe ".backlog" do
    before do
      @iterations = PivotalTracker::Iteration.backlog(@project)
    end

    it "should return an array of Iterations for the given Project" do
      @iterations.should be_a(Array)
      @iterations.first.should be_a(PivotalTracker::Iteration)
    end
  end

  describe ".done" do
    before do
      @iterations = PivotalTracker::Iteration.done(@project)
    end

    it "should return an array of Iterations for the given Project" do
      @iterations.should be_a(Array)
      @iterations.first.should be_a(PivotalTracker::Iteration)
    end
  end

  describe ".current_backlog" do
    before do
      @iterations = PivotalTracker::Iteration.current_backlog(@project)
    end

    it "should return an array of Iterations for the given Project" do
      @iterations.should be_a(Array)
      @iterations.first.should be_a(PivotalTracker::Iteration)
    end
  end

  describe ".team_strength" do
    before do
      @iteration = PivotalTracker::Iteration.current(@project)
    end

    it "should return a Float" do
      @iteration.should respond_to(:team_strength)
      @iteration.team_strength.should be_a(Float)
    end
  end

  describe ".stories" do
    before do
      @iteration = PivotalTracker::Iteration.current(@project)
    end

    it "There should be 1 story in the current iteration" do
      @iteration.stories.should be_a(Array)
      @iteration.stories.length.should eq(1)
      @iteration.stories.first.description.should eq("Generic description")
      @iteration.stories.first.estimate.should eq (2)
    end
  end


end

