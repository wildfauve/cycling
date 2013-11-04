class Developer
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  
  has_and_belongs_to_many :stories
  
  
  def self.create_it(params)
    dev = self.new(params[:developer])
    #story.add_feature(params[:assigned_feature]) if params[:assigned_feature].present?    
    dev.save
    dev
  end
  
  def self.update_it(params)
    dev = self.find(params[:id])    
    dev.update_it(params)
  end

  def self.destroy_it(params)
    dev = self.find(params[:id])
    dev.destroy_it
  end
  
  def self.dev_map(params)
    rex = Regexp.new(params[:q].downcase)
    self.any_of(name: rex).map(&:token_map)
  end
  

  def update_it(params)
    self.attributes = (params[:developer])
    #self.add_feature(params[:assigned_feature]) if params[:assigned_feature].present?    
    save
    self    
  end
  
  def destroy_it
    self.destroy
    self
  end
  
  def token_map
    {:id => _id, :name => name} 
  end
  
  def total_stories
    self.stories.count
  end
  
  def avg_cycle_time
    self.stories.empty? ? 0 : Story.cycle_time(calc: :avg, stories: self.stories, start: :dev_start_date, end: :dev_end_date)
  end

end