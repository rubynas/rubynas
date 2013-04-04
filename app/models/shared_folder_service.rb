class SharedFolderService < ActiveRecord::Base
  attr_accessible :options, :service_class, :shared_folder
  belongs_to :shared_folder
  serialize :options
  
  validates_presence_of :service_class, :shared_folder_id
  
  # @return [Class] a service class
  def service_class
    if service_class = read_attribute("service_class")
      service_class = service_class.constantize if service_class.is_a?(String)
      service_class
    end
  end
end
