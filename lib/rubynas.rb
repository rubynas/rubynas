require 'logger'
require 'grape'
require 'grape-entity'
require 'active_support'
require 'active_support/dependencies'
require 'vmstat'

module Rubynas  
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
  
  class Application
    
  end
  
=begin
  
  Rubynas::Application.routes.draw do
    # application authentication
    devise_for :users

    # api's that are called by the javascript application and others
    mount UserAPI => '/api'
    mount GroupAPI => '/api'
    mount VolumeAPI => '/api'
    mount SystemInformationAPI => '/api'
  
    # fallback route everything will be routed to the index page. Since we use
    # the angular html histroy api a refresh will be called on a real resource
    # every time the user makes a refresh. By rendering the main index the app
    # can pick up the path an show the correct page.
    match '*path' => 'main#index'
    root :to => 'main#index'
  end
=end
end

require 'rubynas/config'

%w(apis models services installers).each do |dir|
  ActiveSupport::Dependencies.autoload_paths.unshift("lib/rubynas/#{dir}")
end

# require 'rubynas/apis/group_api'
# require 'rubynas/apis/system_information_api'
# require 'rubynas/apis/user_api'
# require 'rubynas/apis/volume_api'
# require 'rubynas/models/ldap_group'
# require 'rubynas/models/ldap_org_unit'
# require 'rubynas/models/ldap_user'
# require 'rubynas/models/shared_folder'
# require 'rubynas/models/shared_folder_service'
# require 'rubynas/models/volume'
# require 'rubynas/services/service'
# require 'rubynas/services/share_service'
# require 'rubynas/services/afp_share_service'
