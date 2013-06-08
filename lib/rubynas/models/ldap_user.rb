class LdapUser < ActiveLdap::Base
  ldap_mapping :dn_attribute => 'cn', :scope => :one,
               :prefix => 'ou=users', :classes => [
                 'inetOrgPerson', 'organizationalPerson', 'person', 
                 'posixAccount', 'top'
               ]

  # Associate with primary belonged group
  belongs_to :primary_group, :primary_key => 'gidNumber',
             :class_name => 'LdapGroup'

  # Associate with all belonged groups
  belongs_to :groups, :primary_key => 'uid', :many => 'memberUid',
             :class_name => 'LdapGroup'
             
  # Creates or finds the admin user. The common name has to be 'Admin'
  # @return [LdapUser]
  def self.find_or_create_admin
    user = LdapUser.find('Admin') rescue nil
    user ||= LdapUser.create(
               :common_name => "Admin",
               :mail => "admin@rubynas.com",
               :home_directory => "/root",
               :uid => "admin",
               :surname => "Admin",
               :uid_number => 0,
               :gid_number => 0,
               :user_password => ActiveLdap::UserPassword.sha("secret"))
    user  
  end
end
