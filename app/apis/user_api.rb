class UserAPI < Grape::API
  format :json
  
  class User < Grape::Entity
    expose :common_name, :documentation => { :type => String, :desc => "Full name" }
    expose :given_name, :documentation => { :type => String, :desc => "Firstname" }
    expose :surname, :documentation => { :type => String, :desc => "Lastname" }
    expose :uid, :documentation => { :type => String, :desc => "Login name" }
    expose :home_directory, :documentation => { :type => String, :desc => "Path to the user home" }
    expose :gid_number, :documentation => { :type => Integer, :desc => "ID of the group" }
    expose :uid_number, :documentation => { :type => Integer, :desc => "ID of the user" }
    expose :mail, :documentation => { :type => String, :desc => "E-Mail address" }
  end
  
  resource :users do
    desc "Returns the list of users in the ldap", {
      :object_fields => UserAPI::User.documentation
    }
    get '/' do
      present LdapUser.all, with: UserAPI::User
    end
    
    desc "Adds new user to the ldap"
    params do
      requires :common_name
      requires :given_name
      requires :surname
      requires :uid
      requires :home_directory
      requires :gid_number
      requires :uid_number
      requires :password
      requires :mail
    end
    post '/' do
      password = ActiveLdap::UserPassword.sha(params.delete(:password))
      LdapUser.create(params.merge(:userPassword => password))
      true
    end
    
    desc "Request single user", {
      :object_fields => UserAPI::User.documentation
    }
    get '/:cn' do
      present LdapUser.find(params[:cn]), with: UserAPI::User
    end
    
    desc "Update the user data in the ldap"
    put '/:cn' do
      user = LdapUser.find(params.delete(:cn))
      if params[:password]
        password = ActiveLdap::UserPassword.sha(params.delete(:password))
        params.merge!(:userPassword => password)
      end
      user.update_attributes(params)
    end
    
    desc "Delete user"
    delete '/:cn' do
      LdapUser.find(params.delete(:cn)).destroy
      true
    end
  end
end
