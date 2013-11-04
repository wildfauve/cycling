class DashboardsController < ApplicationController
  
  def index

  end
  
  def cycles
    @dim = Dimension.new.cycle_dimension(params)
    respond_to do |format|
      format.js {render 'cycle_chart', :layout => false }
    end
  end
  
  def completed
    @dim = Dimension.new.completed_stories_dimension(params)
    respond_to do |format|
      format.js {render 'cycle_chart', :layout => false }
    end
  end

  def in_progress
    @dim = Dimension.new.in_progress_stories_dimension(params)
    respond_to do |format|
      format.js {render 'cycle_chart', :layout => false }
    end
  end


end