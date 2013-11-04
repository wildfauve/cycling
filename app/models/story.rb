class Story
  
  attr_reader :dev_tags
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :ref, :type => String
  field :desc, :type => String
  field :start_date, :type => Date
  field :dev_start_date, :type => Date
  field :dev_end_date, :type => Date
  field :test_end_date, type: Date
  field :end_date, :type => Date
  
  belongs_to :feature
  
  has_and_belongs_to_many :developers
  
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

  def self.completed_count(story_list=self)
    story_list.ne(end_date: nil).count
  end

  def self.test_completed_count
    self.ne(test_end_date: nil).count
  end
  
  
  def self.cycle_time(args)
    range = {start: args[:start], end: args[:end]}
    range[:start] = :start_date if !range[:start]
    range[:end] = :end_date if !range[:end]
    args.has_key?(:stories) ? story_list = args[:stories] : story_list = self
    completed_count = self.completed_count(story_list)
    completed = story_list.ne(range[:end] => nil)
    Rails.logger.info(">>>Story#cycle_time  #{story_list.count}, #{completed.count}")
    if args[:calc] == :avg
      total = completed.inject(0) {|result, story| result += story.total_days(range)} / completed_count
    elsif args[:calc] == :high
      total = completed.max {|a,b| a.total_days <=> b.total_days}.total_days(range)
    elsif args[:calc] == :low
      total = completed.min {|a,b| a.total_days <=> b.total_days}.total_days(range)
    elsif args[:calc] == :tot
      total = completed.inject(0) {|result, story| result += story.total_days(range)}
    end
    return total
    
  end
  
  
  def self.completed_stories(range)
    stories = self.ne(range[:start] => nil).ne(range[:end] => nil).
              collect {|story| {start_date: story.start_date, test_end_date: story.test_end_date, end_date: story.end_date, cycle_time: story.total_days(range)}}
    #Rails.logger.info(">>>Story#completed)stories  #{stories}")                  
    stories.sort! {|a,b| a[range[:end]] <=> b[range[:end]] }              
  end
      
  def self.in_progress_count
    self.ne(start_date: nil).where(end_date: nil).count
  end
  
  def self.atleast_started_stories(range)
    stories = self.ne(range[:start] => nil).
              collect {|story| {start_date: story.start_date, test_end_date: story.test_end_date, end_date: story.end_date, cycle_time: story.total_days(range)}}
    stories.sort! {|a,b| a[range[:start]] <=> b[range[:start]] }              
  end
  
  def self.to_csv
    CSV.generate do |csv|
      att = Story.attribute_names
      att << "total_days"
      csv << att
      self.all.each do |s|
        csv << att.inject([]) {|result, name| result << s.send(name)}
      end
    end    
  end
  
  def self.find_by_ref(params)
    self.where(ref: params[:ref]).first
  end
  
  {"story"=>{"ref"=>"S85-01", "desc"=>"", 
    "start_date="=>"", "dev_start_date="=>"25-09-2013", 
    "dev_end_date="=>"25-09-2013", "test_end_date="=>nil, 
    "end_date="=>nil}, "id"=>"522f91b0e4df1c3f91000003"}
  
  def self.api_update(params)
    s = self.find(params[:id])
    #params[:story].keep_if {|p, v| v.present? }
    Rails.logger.info("Story#api_update  #{params.inspect}")
    params[:story].each {|k,v| s.send("#{k}=", v) if v.present?}
    #s.update_it(params)
    s.save
    s
  end
  
  
  def update_it(params)
    #Rails.logger.info(">>>Story#update  #{params[:story].inspect}")    
    self.attributes = params[:story]
    self.add_feature(params[:assigned_feature]) if params[:assigned_feature].present?    
    #Rails.logger.info(">>>Story#update  #{self.changed?}")    
    save
    self    
  end
  
  def destroy_it
    self.destroy
    self
  end
  
  def dev_tags=(dev_ids)
    devs_list = dev_ids.split(",")
    self.developer_ids = devs_list
  end
  
  
  def add_feature(feat)
    self.feature = Feature.find(feat.split(",").first)
  end
  
  def total_days(range=nil)
    range = {start: :start_date, end: :end_date} if !range
    self.send(range[:start]).nil? || self.send(range[:end]).nil? ? 0 : Utilities.working_days_between(self.send(range[:start]), self.send(range[:end]))
  end
  
  def feature_map
    return "".to_json if self.feature.nil? 
    [self.feature.token_map].to_json
  end

  def dev_map
    return "".to_json if self.developers.empty? 
    self.developers.map(&:token_map).to_json
  end
  

end