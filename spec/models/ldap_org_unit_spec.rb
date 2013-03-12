require 'spec_helper'

describe LdapOrgUnit do
  context "#find_or_create" do
    before do
      if group = (LdapOrgUnit.find('testers') rescue nil)
        group.destroy
      end
    end
    
    it "creates the unit" do
      LdapOrgUnit.find_or_create('testers').ou.should == "testers"
    end
    
    it "craetes and finds the unit" do
      LdapOrgUnit.find_or_create('testers') == LdapOrgUnit.find_or_create('testers')
    end
  end
end
