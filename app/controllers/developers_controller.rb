class DevelopersController < ApplicationController
  
  def index
    @devs = Developer.all.asc(:ref)
  end
  
  def show
  end
  
  def new
    @dev = Developer.new
  end
  
  def create
    @dev = Developer.create_it(params)
    respond_to do |format|
      if @dev.valid?
        format.html { redirect_to developers_path }
        format.json
      else
        format.html { render action: "new" }
        format.json
      end
    end      
    
  end
  
  def edit
    @dev = Developer.find(params[:id])
  end
  
  def update
    @dev = Developer.update_it(params)    
    respond_to do |format|
      if @dev.valid?
        format.html { redirect_to developers_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end      
  end
  
  def destroy
    @dev = Developer.destroy_it(params)    
    respond_to do |format|
      if @dev.valid?
        format.html { redirect_to developers_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end          
  end
  
  def query
    @dev_map = Developer.dev_map(params)
    respond_to do |format|
      format.json { render :json => @dev_map }
    end
  end
  
  
end