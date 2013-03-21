require 'spec_helper'

describe LdapGroup do
  context "#find_or_create_administrators" do
    before do
      if group = (LdapGroup.find(:cn => 'Administrators') rescue nil)
        group.destroy
      end
    end
    
    it "creates an admin" do
      LdapGroup.find_or_create_administrators.common_name.should == \
        "Administrators"
    end
    
    it "creates & finds an admin" do
      LdapGroup.find_or_create_administrators.should == \
        LdapGroup.find_or_create_administrators
    end
  end
end
