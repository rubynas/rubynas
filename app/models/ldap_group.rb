class LdapGroup < ActiveLdap::Base
  ldap_mapping :dn_attribute => 'cn', :prefix => 'ou=groups',
               :classes => ['top', 'posixGroup']

  # Associate with primary belonged users
  has_many :primary_members, :foreign_key => 'gidNumber',
           :class_name => "LdapUser", :primary_key => 'gidNumber'

  # Associate with all belonged users
  has_many :members, :wrap => "memberUid",
           :class_name => "LdapUser", :primary_key => 'uid'

  # Creates or finds the admin group. The common name has to be 'Administrators'
  # @return [LdapGroup]
  def self.find_or_create_administrators
    group = LdapGroup.find('Administrators') rescue nil
    group ||= LdapGroup.create :common_name => "Administrators",
                               :gid_number => 0
    group
  end
end