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
end
