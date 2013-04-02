class SharedFolderService < ActiveRecord::Base
  attr_accessible :options, :service_class, :shared_folder_id
end
