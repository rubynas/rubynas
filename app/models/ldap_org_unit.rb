class LdapOrgUnit < ActiveLdap::Base
  ldap_mapping dn_attribute: "ou", :classes => ['organizationalUnit'],
               :scope => :sub, :prefix => ""

  # Creates or finds a unit by name
  # @param [String] name the name of the unit (ou) to find or create
  # @return [LdapOrgUnit]
  def self.find_or_create(name)
    unit = LdapOrgUnit.find(name) rescue nil
    unit ||= LdapOrgUnit.create(:ou => name)
    unit
  end
end
