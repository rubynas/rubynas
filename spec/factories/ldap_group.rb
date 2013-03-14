require 'factory_girl'

FactoryGirl.define do
  factory :ldap_group do
  end
  
  factory :user_ldap_group, :parent => :ldap_group do
    common_name "Users"
    gid_number 1000
  end
  
  factory :admin_ldap_group, :parent => :ldap_group do
    common_name "Administrators"
    gid_number 0
  end
end
