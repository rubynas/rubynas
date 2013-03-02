require 'spec_helper'

describe 'LDAP Authentication', :js => true do
  context "with normal user" do
    before do
      visit '/'
      page.should have_content('Sign in')
      fill_in 'Email', :with => "user@rubynas.com"
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
