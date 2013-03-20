require 'spec_helper'

describe 'Restful Group API' do
  include Rack::Test::Methods

  def app
    GroupAPI
  end
  
  before { LdapGroup.all.each(&:destroy) }
  
  context "GET /groups" do
    before do
      create :user_ldap_group
      create :admin_ldap_group
      get '/groups' 
    end
    subject { last_response }
    
    it { should be_ok }
    its(:body) { should include('Users') }
    its(:body) { should include('Administrators') }
  end
  
  context "GET /groups/:cn" do
    context "with group" do
      before do
        create :user_ldap_group
        get '/groups/Users' 
      end
      subject { last_response }
    
      it { should be_ok }
      its(:body) { should include('Users') }
      its(:body) { should include('1000') }
    end

    context "without user" do
      before { get '/groups/Users' }
      subject { last_response }
  
      its(:status) { should == 404 }
    end
  end
end
