class Dimension
  
  attr_accessor :x, :y, :title, :data
  
  # {:start => <date>, :end => date}
  
  def cycle_dimension(range)
    end_date_type = range[:end].to_sym
    start_date_type = range[:start].to_sym
    comp_stories = Story.completed_stories(start: start_date_type, end: end_date_type)
    dim = []
    self.date_range(comp_stories).each do |date|
      countable = comp_stories.select {|story| story[end_date_type] <= date}
      if countable.count > 0
        dim << [date.to_time.to_i * 1000, countable.inject(0.0) {|result, story| result += story[:cycle_time]} / countable.count ]
      else
        dim << [date.to_time.to_i * 1000, 0]
      end
    end
    end_date_type == :end_date ? title_add = "(based on Story End Date)" : title_add = "(based on Story Test End Date)"
    @title = "Cycle Time Average per Day #{title_add}"  
    @y = "Average Cycle Time"
    @x = "Date"
    @data = dim.to_json
    self
  end
  
  def completed_stories_dimension(range)
    end_date_type = range[:end].to_sym
    start_date_type = range[:start].to_sym
    comp_stories = Story.completed_stories(start: start_date_type, end: end_date_type)
    dim = []
    self.date_range(comp_stories).each do |date| 
      countable = comp_stories.select {|story| story[end_date_type] <= date}
      dim << [date.to_time.to_i * 1000, countable.count ]
    end
    end_date_type == :end_date ? title_add = "(based on Story End Date)" : title_add = "(based on Story Test End Date)"    
    @title = "Completed Stories by Day #{title_add}"
    @y = "Story Count"    
    @x = "Date"    
    @data = dim.to_json
    self
  end
  
  def in_progress_stories_dimension(range)
    end_date_type = range[:end].to_sym
    start_date_type = range[:start].to_sym
    in_prog_stories = Story.atleast_started_stories(start: start_date_type, end: end_date_type)
    dim = []
    self.date_range(in_prog_stories).each do |date| 
      countable = in_prog_stories.select {|story| story[:start_date] <= date && (story[end_date_type] == nil || story[end_date_type] > date)}
      dim << [date.to_time.to_i * 1000, countable.count ]
    end
    end_date_type == :end_date ? title_add = "(based on Story End Date)" : title_add = "(based on Story Test End Date)"    
    @title = "Stories in Progress by Day #{title_add}"
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