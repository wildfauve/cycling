class Api::StoriesController < Api::ApplicationController
  
  caches_action :search
  
  def index
    @stories = Story.all.asc(:ref)
  end
  
  def create
    @crime = Crime.create_the_crime(params[:crime])
    respond_to do |format|
      if @crime.valid?
        format.json { render 'api/crimes/create', :status => :created, :location => url_for(api_crime_path(@crime)) }
      else
        format.json
      end
    end
  end
    
  def update
    @story = Story.api_update(params)
    respond_to do |format|
      if @story.valid?
        format.json { render 'api/stories/update', :status => :created, :location => url_for(api_story_path(@story)) }
      else
        format.json
      end
    end
  end
  
  def search
    # Test JSON Return Size
    @stories = Story.all
    respond_to do |format|
      format.json {render 'api/stories/size_test'}
    end
  end
  
end
