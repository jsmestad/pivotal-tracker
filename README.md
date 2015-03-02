## pivotal-tracker.rb - the original ruby gem

{<img src="https://secure.travis-ci.org/jsmestad/pivotal-tracker.png" />}[http://travis-ci.org/jsmestad/pivotal-tracker]
{<img src="https://badge.fury.io/rb/pivotal-tracker.png" alt="Gem Version" />}[http://rubygems.org/gems/pivotal-tracker]

#### NOTICE

I am currently re-writing this gem to address the biggest feature requests that are long overdue:

* Gem is thread-safe
* Support Pivotal Tracker APIv5 and dropping V3 support
* Overhauled spec suite

This will become the `v1.x` release.

### Original README (for `v0.x` releases)

## Features

* Compatible with Pivotal Tracker API version 3
* ActiveRecord-style Wrapper API
* Support for SSL protected repositories

## Overview

    PivotalTracker::Client.token('myusername@email.com', 'secretpassword')        # Automatically fetch API Token
    PivotalTracker::Client.token = 'jkfduisj97823974j2kl24899234'                 # Manually set API Token

    PivotalTracker::Client.timeout = 50                                           # Set timeout on the connection with pivotal. Default is 60 seconds

    @projects = PivotalTracker::Project.all                                       # return all projects
    @a_project = PivotalTracker::Project.find(84739)                              # find project with a given ID

    @a_project.stories.all                                                        # return all stories for "a_project"
    @a_project.stories.all(:label => 'overdue', :story_type => ['bug', 'chore'])  # return all stories that match the passed filters
    @a_project.stories.find(847762630)                                            # find story with a given ID

    @a_project.stories.create(:name => 'My Story', :story_type => 'feature')      # create a story for this project

    # all tracker defined filters are allowed, as well as :limit & :offset for pagination

    # The below pattern below is planned to be added to the final release:

    @a_project.stories << PivotalTracker::Story.new(84739, :name => 'Ur Story')   # same as earlier story creation, useful for copying/cloning from proj


    @story = @a_project.stories.find(847762630)
    @story.notes.all                                                              # return all notes (comments) for a story
    @story.notes.create(:text => 'A new comment', :noted_at => '06/29/2010 05:00 EST')  # add a new note

    @story.tasks.all                                                              # return all tasks for a story
    @story.tasks.create(:description => 'Task Description')  # add a new task


    @story.attachments                                                            # return an array of all attachment items (data only, not the files)
    @story.upload_attachment(file_path)                                           # add a file attachment to @story that can be found at file_path


    # All 4 examples below return a PivotalTracker::Story from the new project, with the same story ID

    @story.move_to_project(123456)                                                # move @story to the project with ID 123456
    @story.move_to_project('123456')                                              # same as above
    @story.move_to_project(@project)                                              # move @story to @project
    @story.move_to_project(@another_story)                                        # move @story into the same project as @another_story


    # Connect to custom API endpoint
    PivotalTracker::Client.tracker_host = 'www.my-pivotal-tracker.com'

The API is based on the following this gist: http://gist.github.com/283120

## Additional Information

* Wiki: https://wiki.github.com/jsmestad/pivotal-tracker
* Documentation: http://rdoc.info/projects/jsmestad/pivotal-tracker
* Pivotal API v3 Docs: http://www.pivotaltracker.com/help/api?version=v3

## Contributors along the way

* Justin Smestad (https://github.com/jsmestad)
* Jon Mischo (https://github.com/supertaz)
* Gabor Ratky (https://github.com/rgabo)

