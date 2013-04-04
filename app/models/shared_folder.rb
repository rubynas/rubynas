class SharedFolder < ActiveRecord::Base
  attr_accessible :name, :path
  
  validates_presence_of :name, :path
  
  validate :path_exists
  
  # Converts the shared folder path to path object
  # @returns [Pathname]
  def pathname
    Pathname.new(path)
  end
  
  # Validate if the path is given and is really a directory
  def path_exists
    if path
      errors.add(:path, "Path dosn't exist") unless pathname.exist? 
      errors.add(:path, "Path isn't a directory") unless pathname.directory?
    end
  end
end
