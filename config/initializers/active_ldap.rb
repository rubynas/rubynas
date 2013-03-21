ActiveLdap::Base.setup_connection(
  :host => '127.0.0.1',
  :port => 10389,
  :base => 'dc=rubynas,dc=com',
  :logger => Rails.logger,
  :bind_dn => "cn=admin,dc=rubynas,dc=com",
  :password_block => Proc.new { 'secret' },
  :allow_anonymous => false,
  :try_sasl => false
)

# Setup default account and structure if they don't exist in the repository
LdapOrgUnit.find_or_create('users')
LdapOrgUnit.find_or_create('groups')
  
unless Rails.env.test?
  LdapUser.find_or_create_admin
  LdapGroup.find_or_create_administrators
end
