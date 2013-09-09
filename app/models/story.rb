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
    self.add_feature(params[:assigned_feature]) if params[:assigned_feature].present?    
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