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
  
  context "DELETE /groups" do
    context "with group" do
      before do
        create :user_ldap_group
        LdapGroup.all.should_not be_empty
        delete '/groups/Users' 
      end
      subject { last_response }
    
      it { should be_ok }
      specify { LdapGroup.all.should be_empty }
    end

    context "without user" do
      before { delete '/groups/Users' }
      subject { last_response }
  
      its(:status) { should == 404 }
    end
  end
  
  context "POST /groups" do
    it "adds a new group" do
      post '/groups', common_name: "Foo", gid_number: 1001
      last_response.status.should == 201
    end
    
    it "returns a 400 if params are missing" do
      post '/groups'
      last_response.status.should == 400
    end
  end
end
