class UserAPI < Grape::API
  format :json

  rescue_from ActiveLdap::EntryNotFound do |error|
    Rack::Response.new({
      'status'  => 404,
      'message' => error.message
    }.to_json, 404)
  end

  class User < Grape::Entity
    expose :common_name, documentation: { type: String, desc: 'Full name' }
    expose :given_name, documentation: { type: String, desc: 'Firstname' }
    expose :surname, documentation: { type: String, desc: 'Lastname' }
    expose :uid, documentation: { type: String, desc: 'Login name' }
    expose :home_directory,
           documentation: { type: String, desc: 'Path to the user home' }
    expose :gid_number,
           documentation: { type: Integer, desc: 'ID of the group' }
    expose :uid_number, documentation: { type: Integer, desc: 'ID of the user' }
    expose :mail, documentation: { type: String, desc: 'E-Mail address' }
    expose :login_shell, documentation: { type: String, desc: 'The shell used for ssh login' }
  end

  desc 'Returns the list of users in the ldap', {
    :object_fields => UserAPI::User.documentation
  }
  get '/' do
    present LdapUser.all, with: UserAPI::User
  end

  desc 'Returns a template for new users', {
    :object_fields => UserAPI::User.documentation
  }
  get '/template' do
    next_uid_number = LdapUser.all.map(&:uid_number).max.to_i + 1
    next_uid_number = 1000 if next_uid_number < 1000
    { uid_number: next_uid_number,
      gid_number: 1000,
      home_directory: '/home/' }
  end

  desc 'Adds new user to the ldap'
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
    requires :login_shell
  end
  post '/' do
    password = ActiveLdap::UserPassword.sha(params.delete(:password))
    LdapUser.create(params.merge(:userPassword => password))
    true
  end

  desc 'Request single user', {
    :object_fields => UserAPI::User.documentation
  }
  get '/:cn' do
    present LdapUser.find(params[:cn]), with: UserAPI::User
  end

  desc 'Update the user data in the ldap'
  put '/:cn' do
    user = LdapUser.find(params.delete(:cn))
    if params[:password]
      password = ActiveLdap::UserPassword.sha(params.delete(:password))
      params.merge!(:userPassword => password)
    end
    user.update_attributes(params)
  end

  desc 'Delete user'
  delete '/:cn' do
    LdapUser.find(params.delete(:cn)).destroy
    true
  end
end
