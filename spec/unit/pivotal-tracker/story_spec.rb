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
  
  context ".new" do
    
    def story_for(attrs)
      story = @project.stories.new(attrs)
      @story = Hash.from_xml(story.send(:to_xml))['story']
    end
    
    describe "attributes that are not sent to the tracker" do
      
      it "should include id" do
        story_for(:id => 10)["id"].should be_nil
      end
      
      it "should include url" do
        story_for(:url => "somewhere")["url"].should be_nil
      end
      
      it "should include created_at" do
        story_for(:created_at => Time.now)["created_at"].should be_nil
      end
      
      it "should include accepted_at" do
        story_for(:accepted_at => Time.now)["accepted_at"].should be_nil
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
      
      it "should include other_id" do
        story_for(:other_id => 10)["other_id"].should == "10"
      end      
      
      # the tracker returns 422 when this is included, even if it is not used
      # it "should include jira_id" do
      #   story_for(:jira_id => 10)["jira_id"].should == "10"
      # end
      # 
      # it "should include jira_url" do
      #   story_for(:jira_url => "somewhere")["jira_url"].should == "somewhere"
      # end
      
    end

  end

end
