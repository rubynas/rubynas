class GroupAPI < Grape::API
  format :json
  
  class Group < Grape::Entity
    expose :common_name, :documentation => { :type => String, :desc => "Group name" }
    expose :gid_number, :documentation => { :type => Integer, :desc => "ID of the group" }
  end
  
  resource :groups do
    desc "Returns the list of users in the ldap", {
      :object_fields => GroupAPI::Group.documentation
    }
    get '/' do
      present LdapGroup.all, with: GroupAPI::Group
    end
    
    desc "Return a single group"
    get '/:cn' do
      present LdapGroup.find(params[:cn]), with: GroupAPI::Group
    end
  end
end
