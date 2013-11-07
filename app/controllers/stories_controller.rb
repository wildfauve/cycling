class StoriesController < ApplicationController
  
  def index
    @stories = Story.all.asc(:ref)
  end
  
  def show
    @story = Story.find(params[:id])
    respond_to do |f|
      f.json 
      f.html
    end
  end
  
  def new
    @story = Story.new
  end
  
  def create
    @story = Story.create_it(params)
    respond_to do |format|
      if @story.valid?
        format.html { redirect_to stories_path }
        format.json
      else
        format.html { render action: "new" }
        format.json
      end
    end      
    
  end
  
  def edit
    @story = Story.find(params[:id])
  end
  
  def update
    @story = Story.update_it(params)    
    respond_to do |format|
      if @story.valid?
        format.html { redirect_to stories_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end      
  end
  
  def destroy
    @story = Story.destroy_it(params)    
    respond_to do |format|
      if @story.valid?
        format.html { redirect_to stories_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end          
  end
  
  def export
    respond_to do |format|
      format.csv { render text: Story.to_csv }
    end    
  end
  
  
end