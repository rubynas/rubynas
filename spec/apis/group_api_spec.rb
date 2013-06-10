require 'spec_helper'

describe 'Restful Group API' do
  include Rack::Test::Methods

  def app
    GroupAPI
  end
  
  before { LdapGroup.all.each(&:destroy) }
  
  context "GET /" do
    before do
      create :user_ldap_group
      create :admin_ldap_group
      get '/' 
    end
    subject { last_response }
    
    it { should be_ok }
    its(:body) { should include('Users') }
    its(:body) { should include('Administrators') }
  end
  
  context "GET /:cn" do
    context "with group" do
      before do
        create :user_ldap_group
        get '/Users' 
      end
      subject { last_response }
    
      it { should be_ok }
      its(:body) { should include('Users') }
      its(:body) { should include('1000') }
    end

    context "without user" do
      before { get '/Users' }
      subject { last_response }
  
      its(:status) { should == 404 }
    end
  end
  
  context "DELETE /" do
    context "with group" do
      before do
        create :user_ldap_group
        LdapGroup.all.should_not be_empty
        delete '/Users' 
      end
      subject { last_response }
    
      it { should be_ok }
      specify { LdapGroup.all.should be_empty }
    end

    context "without user" do
      before { delete '/Users' }
      subject { last_response }
  
      its(:status) { should == 404 }
    end
  end
  
  context "POST /" do
    it "adds a new group" do
      post '/', common_name: "Foo", gid_number: 1001
      last_response.status.should == 201
    end
    
    it "returns a 400 if params are missing" do
      post '/'
      last_response.status.should == 400
    end
  end
  
  context "PUT /:cn" do
    context "with user" do
      before do
        create :user_ldap_group
        put '/Users', common_name: "Foo", gid_number: 1001
      end
      subject { LdapGroup.find('Users') }
      
      its(:gid_number) { should == 1001 }
    end
    
    context "without user" do
      before { put '/Users', common_name: "Foo", gid_number: 1001 }
      subject { last_response }
  
      its(:status) { should == 404 }
    end
  end
end
