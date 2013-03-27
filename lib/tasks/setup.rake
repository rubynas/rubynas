desc "Application setup"
task "app:setup" => :environment do
  # In the production environment should the root volume always be available
  unless Volume.find_by_name_and_path("System Volume", "/")
    Volume.create(name: "System Volume", path: "/")
  end

  # Setup default account and structure if they don't exist in the repository
  LdapOrgUnit.find_or_create('users')
  LdapOrgUnit.find_or_create('groups')
  LdapUser.find_or_create_admin
  LdapGroup.find_or_create_administrators
end
