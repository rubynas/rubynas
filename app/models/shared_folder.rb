class SharedFolder < ActiveRecord::Base
  attr_accessible :name, :path
  has_many :shared_folder_services
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
  
  # Searches for the shared folder service that is identified by the given
  # service class.
  # @param [Class, String] service_class a klass like AfpShareService
  # @return [SharedFolderService, nil] the service configuration or nil if
  #   no confiuration was found
  def [](service_class)
    if service = shared_folder_services.where(service_class: service_class).first
      service.options
    end
  end
end
