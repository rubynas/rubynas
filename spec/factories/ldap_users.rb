require 'factory_girl'

FactoryGirl.define do
  factory :ldap_user do
    common_name "User"
    mail "user@rubynas.com"
    home_directory "/home/user"
    uid "user"
    surname "User"
    uid_number 1000
    gid_number 1000
  end
  
  factory :admin_ldap_user, :parent => :ldap_user do
    common_name "Admin"
    mail "admin@rubynas.com"
    home_directory "/root"
    uid "example_admin"
    surname "Admin"
    uid_number 0
    gid_number 0
  end
end
