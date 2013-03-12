require 'spec_helper'

describe LdapUser do
  context "#find_or_create_admin" do
    before do
      if user = (LdapUser.find(:cn => Admin) rescue nil)
        user.destroy
      end
    end
    
    it "creates an admin" do
      LdapUser.find_or_create_admin.common_name.should == "Admin"
    end
    
    it "creates & finds an admin" do
      LdapUser.find_or_create_admin.should == LdapUser.find_or_create_admin
    end
  end
end