require 'spec_helper'

describe BaseInstaller do
  subject { described_class.new('rubynas.com', 'admin', 'secret') }
  
  its(:domain) { should == 'rubynas.com' }
  its(:admin) { should == 'admin' }
  its(:password) { should == 'secret' }
  
  its(:domain_parts) { should == ['rubynas', 'com'] }
  its(:ldap_base) { should == 'dc=rubynas,dc=com' }
  its(:admin_ldap_dn) { should == 'cn=admin,dc=rubynas,dc=com' }
  
  context 'non root' do  
    its(:root?) { should be_false }
  end
  
  context 'root' do
    before { Process.stub(:uid) { 0 } } 

    its(:root?) { should be_true }
  end
end
