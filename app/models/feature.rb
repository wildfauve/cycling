class Feature
  
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :ref, type: String
  field :desc, type: String
  field :priority, type: String
  field :story_points, type: Integer
  
  has_many :stories
  
  def self.create_it(params)
    feature = self.new(params)
    feature.save
    feature
  end
  
  def self.update_it(params)
    feature = self.find(params[:id])
    feature.update_it(params[:feature])
  end

  def self.destroy_it(params)
    feature = self.find(params[:id])
    feature.destroy_it
  end

  def self.proj_map(params)
    rex = Regexp.new(params[:q].downcase)
    self.where(:ref => rex).map(&:token_map)
  end

  
  def update_it(params)
    self.attributes = (params)
    save
    self    
  end
  
  def destroy_it
    self.destroy
    self
  end
  
  def token_map
    {:id => _id, :name => ref} 
  end

  def number_stories
    self.stories.count
  end
  
  def total_cycle_time
    self.stories.inject(0) {|result, story| result += story.total_days}
  end

end