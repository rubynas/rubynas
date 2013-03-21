class GroupAPI < Grape::API
  format :json
  
  class Group < Grape::Entity
    expose :common_name, :documentation => { :type => String, :desc => "Group name" }
    expose :gid_number, :documentation => { :type => Integer, :desc => "ID of the group" }
  end
  
  resource :groups do
    desc "Returns the list of groups in the ldap", {
      :object_fields => GroupAPI::Group.documentation
    }
    get '/' do
      present LdapGroup.all, with: GroupAPI::Group
    end
    
    desc "Return a single group"
    get '/:cn' do
      begin
        present LdapGroup.find(params[:cn]), with: GroupAPI::Group
      rescue ActiveLdap::EntryNotFound
        throw :error, :status => 404
      end
    end
    
    desc "Delete the passed group"
    delete '/:cn' do
      begin
        LdapGroup.find(params[:cn]).destroy
        ""
      rescue ActiveLdap::EntryNotFound
        throw :error, :status => 404
      end
    end
    
    desc "Add a new group"
    params do
      requires :common_name, type: String
      requires :gid_number, type: Fixnum
    end
    post '/' do
      LdapGroup.create(params)
      ""
    end
    
    desc "Update a group completely"
    params do
      requires :common_name, type: String
      requires :gid_number, type: Fixnum
    end
    put '/:cn' do
      begin
        LdapGroup.find(params.delete(:cn)).update_attributes(params)
        ""
      rescue ActiveLdap::EntryNotFound
        throw :error, :status => 404
      end
    end
  end
end
