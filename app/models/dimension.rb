class Dimension
  
  attr_accessor :x, :y, :title, :data
  
  def cycle_dimension
    comp_stories = Story.completed_stories
    dim = []
    self.date_range(comp_stories).each do |date|
      countable = comp_stories.select {|story| story[:end_date] <= date}
      if countable.count > 0
        dim << [date.to_time.to_i * 1000, countable.inject(0.0) {|result, story| result += story[:cycle_time]} / countable.count ]
      else
        dim << [date.to_time.to_i * 1000, 0]
      end
    end
    @title = "Cycle Time Average per Day"  
    @y = "Average Cycle Time"
    @x = "Date"
    @data = dim.to_json
    self
  end
  
  def completed_stories_dimension
    comp_stories = Story.completed_stories
    dim = []
    self.date_range(comp_stories).each do |date| 
      countable = comp_stories.select {|story| story[:end_date] <= date}
      dim << [date.to_time.to_i * 1000, countable.count ]
    end
    @title = "Completed Stories by Day"
    @y = "Story Count"    
    @x = "Date"    
    @data = dim.to_json
    self
  end
  
  def in_progress_stories_dimension
    in_prog_stories = Story.atleast_started_stories
    dim = []
    self.date_range(in_prog_stories).each do |date| 
      countable = in_prog_stories.select {|story| story[:start_date] <= date && (story[:end_date] == nil || story[:end_date] > date)}
      dim << [date.to_time.to_i * 1000, countable.count ]
    end
    @title = "Stories in Progress by Day"
    @y = "Story Count"    
    @x = "Date"    
    @data = dim.to_json
    self    
  end
  
  def date_range(stories)
    first_date = stories.min {|a,b| a[:start_date] <=> b[:start_date]}[:start_date]
#    last_date = stories.max {|a,b| a[:end_date] <=> b[:end_date]}[:end_date]
    (first_date..Date.today)
  end
  
  
end