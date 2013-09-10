class Story
  
  @@states = [""]
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :ref, :type => String
  field :desc, :type => String
  field :start_date, :type => Date
  field :end_date, :type => Date
  
  belongs_to :feature
  
  validates_uniqueness_of :ref
  
  def self.create_it(params)
    story = self.new(params[:story])
    story.add_feature(params[:assigned_feature]) if params[:assigned_feature].present?    
    story.save
    story
  end
  
  def self.update_it(params)
    story = self.find(params[:id])    
    story.update_it(params)
  end

  def self.destroy_it(params)
    story = self.find(params[:id])
    story.destroy_it
  end

  def self.completed_count
    self.ne(end_date: nil).count
  end
  
  def self.cycle_time(args)
    @@completed_count ||= self.completed_count
    @@completed ||= self.ne(end_date: nil)
    if args[:calc] == :avg
      total = @@completed.inject(0) {|result, story| result += story.total_days} / @@completed_count
    elsif args[:calc] == :high
      total = @@completed.max {|a,b| a.total_days <=> b.total_days}.total_days
    elsif args[:calc] == :low
      total = @@completed.min {|a,b| a.total_days <=> b.total_days}.total_days
    elsif args[:calc] == :tot
      total = @@completed.inject(0) {|result, story| result += story.total_days}
    end
    return total
    
  end
  
  def self.cycle_dimension
    stories = self.ne(start_date: nil).collect {|story| {start_date: story.start_date, end_date: story.end_date, cycle_time: story.total_days}}
    first_date = stories.min {|a,b| a[:start_date] <=> b[:start_date]}[:start_date]
    last_date = stories.keep_if {|story| !story[:end_date].nil?}.max {|a,b| a[:end_date] <=> b[:end_date]}[:end_date]
    stories.sort! {|a,b| a[:end_date] <=> b[:end_date] }
    dim = []
    (first_date..last_date).each do |date|
      countable = stories.select {|story| story[:end_date] <= date}
      if countable.count > 0
        dim << [date.to_time.to_i * 1000, countable.inject(0.0) {|result, story| result += story[:cycle_time]} / countable.count ]
      else
        dim << [date.to_time.to_i * 1000, 0]
      end
    end
    dim.to_json
  end
  
  def update_it(params)
    self.attributes = (params[:story])
    self.add_feature(params[:assigned_feature]) if params[:assigned_feature].present?    
    save
    self    
  end
  
  def destroy_it
    self.destroy
    self
  end
  
  def add_feature(feat)
    self.feature = Feature.find(feat.split(",").first)
  end
  
  def total_days
    self.start_date.nil? || self.end_date.nil? ? 0 : Utilities.working_days_between(self.start_date, self.end_date)
  end
  
  def feature_map
    return "".to_json if self.feature.nil? 
    [self.feature.token_map].to_json
  end


end