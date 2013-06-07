require 'spec_helper'

describe PivotalTracker::Story do
  before do
    @project = PivotalTracker::Project.find(102622)
  end

  context ".all" do
    it "should return all stories" do
      @project.stories.all.should be_a(Array)
      @project.stories.all.first.should be_a(PivotalTracker::Story)
    end

    it "should allow filtering" do
      @project.stories.all(:story_type => ['bug']).should be_a(Array)
      @project.stories.all(:story_type => ['feature']).should be_a(Array)
    end

    it "should cache stories" do
      count = @project.stories.all.count
      @project.stories.all.count.should == count
      bugs_count = @project.stories.all(:story_type => ['bug']).count
      bugs_count.should_not == count
      @project.stories.all(:story_type => ['bug']).count.should == bugs_count
    end

  end

  context ".find" do
    it "should return the matching story" do
      @project.stories.find(4459994).should be_a(PivotalTracker::Story)
    end
  end

  context ".create" do
    it "should return the created story" do
      @project.stories.create(:name => 'Create Stuff').should be_a(PivotalTracker::Story)
    end

    context "on failure" do
      before do
        FakeWeb.register_uri(:post, "#{PivotalTracker::Client.api_url}/projects/#{@project.id}/stories",
          :body => %{<?xml version="1.0" encoding="UTF-8"?>
             <errors>
               <error>error#1 message</error>
               <error>error#2 message</error>
             </errors>%},
           :status => "422")
      end

      it "should not raise an exception" do
        expect { @project.stories.create }.to_not raise_error(Exception)
      end

      it "should report errors encountered" do
        story = @project.stories.create :name => "Invalid story"
        story.errors.messages.should =~ ["error#1 message", "error#2 message"]
      end
    end
  end

  context ".attachments" do
    it "should return an array of attachments" do
      @story = @project.stories.find(4460598)
      @story.attachments.should be_a(Array)
      @story.attachments.first.should be_a(PivotalTracker::Attachment)
    end
  end
  
  context ".move" do
    let(:project_id) { @project.id }
    let(:top_story_id) {4460598}
    let(:bottom_story_id) {4459994}
    let(:top_story) { @project.stories.find(top_story_id) }
    let(:bottom_story) { @project.stories.find(bottom_story_id) }
    
    it "should return the moved story when moved before" do      
      expected_uri = "#{PivotalTracker::Client.api_url}/projects/#{project_id}/stories/#{top_story_id}/moves?move\[move\]=before&move\[target\]=#{bottom_story_id}"
      FakeWeb.register_uri(:post, expected_uri, :body => %{<story><id type="integer">#{top_story_id}</id></story>})
      @moved_story = top_story.move(:before, bottom_story)
      @moved_story.should be_a(PivotalTracker::Story)
      @moved_story.id.should be(top_story_id)
    end
    
    it "should return the moved story when moved after" do
      expected_uri = "#{PivotalTracker::Client.api_url}/projects/#{project_id}/stories/#{bottom_story_id}/moves?move\[move\]=after&move\[target\]=#{top_story_id}"
      FakeWeb.register_uri(:post, expected_uri, :body => %{<story><id type="integer">#{bottom_story_id}</id></story>})
      @moved_story = bottom_story.move(:after, top_story)
      @moved_story.should be_a(PivotalTracker::Story)
      @moved_story.id.should be(bottom_story_id)
    end
    
    it "should raise an error when trying to move in an invalid position" do
      expect { top_story.move(:next_to, bottom_story) }.to raise_error(ArgumentError)
    end
  end

  context ".move_to_project" do
    let(:expected_uri) {"#{PivotalTracker::Client.api_url}/projects/#{project_id}/stories/#{story_id}"}
    let(:project_id) { @project.id }
    let(:movable_story) { @project.stories.find(4459994) }
    let(:story_id) { movable_story.id }
    let(:target_project) { PivotalTracker::Project.new(:id => 103014) }

    before do
      FakeWeb.register_uri(:put, expected_uri, :body => %{<?xml version="1.0" encoding="UTF-8"?>
                                                       <story>
                                                         <project_id type="integer">#{target_project.id}</project_id>
                                                       </story>})
    end

    it "should return an updated story from the target project when passed a PivotalTracker::Story" do
      target_story = PivotalTracker::Story.new(:project_id => target_project.id)
      response = movable_story.move_to_project(target_story)
      response.should_not be_nil
      response.project_id.should == target_story.project_id
    end

    it "should return an updated story from the target project when passed a PivotalTracker::Project" do
      response = movable_story.move_to_project(target_project)
      response.project_id.should == target_project.id
    end

    it "should return an updated story from the target project when passed a String" do
      response = movable_story.move_to_project(target_project.id.to_s)
      response.project_id.should == target_project.id
    end

    it "should return an updated story from the target project when passed an Integer"do
      response = movable_story.move_to_project(target_project.id.to_i)
      response.project_id.should == target_project.id
    end
  end

  context ".new" do

    def story_for(attrs)
      story = @project.stories.new(attrs)
      @story = Crack::XML.parse(story.send(:to_xml))['story']
    end

    describe "attributes that are not sent to the tracker" do

      it "should include id" do
        story_for(:id => 10)["id"].should be_nil
      end

      it "should include url" do
        story_for(:url => "somewhere")["url"].should be_nil
      end

    end

    describe "attributes that are sent to the tracker" do

      it "should include name" do
        story_for(:name => "A user should...")["name"].should == "A user should..."
      end

      it "should include description" do
        story_for(:description => "desc...")["description"].should == "desc..."
      end

      it "should include story_type" do
        story_for(:story_type => "feature")["story_type"].should == "feature"
      end

      it "should include estimate" do
        story_for(:estimate => 5)["estimate"].should == "5"
      end

      it "should include current_state" do
        story_for(:current_state => "accepted")["current_state"].should == "accepted"
      end

      it "should include requested_by" do
        story_for(:requested_by => "Joe Doe")["requested_by"].should == "Joe Doe"
      end

      it "should include owned_by" do
        story_for(:owned_by => "Joe Doe")["owned_by"].should == "Joe Doe"
      end

      it "should include labels" do
        story_for(:labels => "abc")["labels"].should == "abc"
      end

      describe "should include other_id" do
        it "when passed a string" do
          story_for(:other_id => "aa10bb")["other_id"].should == "aa10bb"
        end
        it "when passed an integer" do
          story_for(:other_id => 10)["other_id"].should == "10"
        end
      end

      it "should include integration_id" do
        story_for(:integration_id => 1000)["integration_id"].should == '1000'
      end

      it "should not include integration_id if it doesn't exist" do
        story_for(:other_id => 1000).keys.should_not include("integration_id")
      end

      it "should not include other_id if it doesn't exist" do
        story_for(:project_id => 1000).keys.should_not include("other_id")
      end

      # the tracker returns 422 when this is included, even if it is not used
      # it "should include jira_id" do
      #   story_for(:jira_id => 10)["jira_id"].should == "10"
      # end
      #
      # it "should include jira_url" do
      #   story_for(:jira_url => "somewhere")["jira_url"].should == "somewhere"
      # end

      context "date attributes" do
        before do
          @datestring = "1984-09-20T10:23:00+00:00"
          @date = DateTime.new(1984, 9, 20, 10, 23, 0, 0)
        end

        [:created_at, :accepted_at].each do |date_attribute|
          it "should include #{date_attribute} date when given a string" do
            story_for(:created_at => @date.to_s)["created_at"].should == @datestring
          end

          it "should include #{date_attribute} date when given a Time" do
            story_for(:created_at => Time.parse(@date.to_s).utc)["created_at"].should == @datestring
          end

          it "should include #{date_attribute} date when given a DateTime" do
            story_for(:created_at => @date)["created_at"].should == @datestring
          end

          it "should include #{date_attribute} date when given a Date" do
            # Dates don't have time zones, but the time will be in local time, so we convert the date to create the expectation
            story_for(:created_at => Date.new(1984, 9, 20))["created_at"].should == DateTime.new(1984, 9, 20).to_s
          end
        end
      end
    end

  end

end
