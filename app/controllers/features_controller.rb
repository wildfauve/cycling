class FeaturesController < ApplicationController
  
  def index
    @features = Feature.all.asc(:ref)
  end
  
  def show
  end
  
  def new
    @feature = Feature.new
  end
  
  def create
    @feature = Feature.create_it(params[:feature])
    respond_to do |format|
      if @feature.valid?
        format.html { redirect_to features_path }
        format.json
      else
        format.html { render action: "new" }
        format.json
      end
    end      
    
  end
  
  def edit
    @feature = Feature.find(params[:id])
  end
  
  def update
    @feature = Feature.update_it(params)    
    respond_to do |format|
      if @feature.valid?
        format.html { redirect_to features_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end      
  end
  
  def destroy
    @feature = Feature.destroy_it(params)    
    respond_to do |format|
      if @feature.valid?
        format.html { redirect_to features_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end          
  end
  
  def query
    @feat_map = Feature.proj_map(params)
    respond_to do |format|
      format.json { render :json => @feat_map }
    end
  end
  
end