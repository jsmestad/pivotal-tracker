require 'pivotal_tracker'
require 'test/unit'

class PivotalTrackerTest < Test::Unit::TestCase
  
  def setup
    @tracker = Tracker.new
  end
  
  def test_assert_stories_return
    assert_equal 3, @tracker.stories.size
  end
  
  def test_assert_project_response
    project = @tracker.project
    assert_equal "Factory Test", project[:name]
    assert_equal "1", project[:iteration_length]
  end
  
  def test_find_without_filters
    result = @tracker.find
    assert_equal @tracker.stories.size, result.size
  end
  
  def test_find_with_filters
    result = @tracker.find :name => 'Create another one'
    assert_equal result[0][:name], 'Create another one'
  end
  
  def test_assert_story_creation
    current_size = @tracker.stories.size
    story = {
      :name => 'Create another one',
      :story_type => "feature",
      :requested_by => "Justin Smestad"
    }
    @tracker.create_story(story)
    assert_equal (current_size + 1), @tracker.stories.size
  end
  
  def test_story_updates
    story = {
      :id => 272626,
      :name => 'This has changed'
    }
    @tracker.update_story(story)
    assert_equal @tracker.find_story(story[:id])[:name], story[:name]
  end
  
  def test_story_deletion
    current_size = @tracker.stories.size
    id = @tracker.stories[0][:id]
    @tracker.delete_story(id)
    assert_equal (current_size - 1), @tracker.stories.size
  end
  
end