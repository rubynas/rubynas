class GroupApi < Grape::API
  format :json

  rescue_from ActiveLdap::EntryNotFound do |e|
    Rack::Response.new([e.inspect], 404)
  end

  class Group < Grape::Entity
    expose :common_name, documentation: { type: String, desc: 'Group name' }
    expose :gid_number,
           documentation: { type: Integer, desc: 'ID of the group' }
  end

  desc 'Returns the list of groups in the ldap', {
    :object_fields => GroupApi::Group.documentation
  }
  get '/' do
    present LdapGroup.all, with: GroupApi::Group
  end

  desc 'Return a single group'
  get '/:cn' do
    present LdapGroup.find(params[:cn]), with: GroupApi::Group
  end

  desc 'Delete the passed group'
  delete '/:cn' do
    LdapGroup.find(params.delete(:cn)).destroy
    ''
  end

  desc 'Add a new group'
  params do
    requires :common_name, type: String
    requires :gid_number, type: Fixnum
  end
  post '/' do
    LdapGroup.create(params)
    ''
  end

  desc 'Update a group completely'
  params do
    requires :common_name, type: String
    requires :gid_number, type: Fixnum
  end
  put '/:cn' do
    LdapGroup.find(params.delete(:cn)).update_attributes(params)
    ''
  end
end
