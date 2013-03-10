class LdapGroup < ActiveLdap::Base
  ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=groups',
               :classes => ['top', 'posixGroup']

  # Associate with primary belonged users
  has_many :primary_members, :foreign_key => 'gidNumber',
           :class_name => "LdapUser", :primary_key => 'gidNumber'

  # Associate with all belonged users
  has_many :members, :wrap => "memberUid",
           :class_name => "LdapUser", :primary_key => 'uid'
end