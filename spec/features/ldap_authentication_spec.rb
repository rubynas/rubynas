require 'spec_helper'

describe 'LDAP Authentication', :js => true do
  before(:all) do
    LdapUser.all.each(&:destroy)
    create :ldap_user
  end
  
  context "with normal user" do
    before do
      visit '/'
      page.should have_content('Sign in')
      fill_in 'E-Mail', :with => "user@rubynas.com"
      fill_in 'Password', :with => "secret"
      click_on 'Sign in'
    end
    
    it "logins in to the application with ldap user" do
      page.should have_content('System Summary')
    end
  
    it "logout from the application" do
      click_on 'Logout'
      page.should have_content('Sign in')
    end
  end
end
