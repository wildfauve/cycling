class DashboardsController < ApplicationController
  
  def index

  end
  
  def cycles
    @dims = Story.cycle_dimension    
    respond_to do |format|
      format.js {render 'cycle_chart', :layout => false }
    end
  end

end