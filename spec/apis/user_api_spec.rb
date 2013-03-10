require 'spec_helper'

describe 'Restful User API' do
  include Rack::Test::Methods

  def app
    UserAPI
  end
  
  before { LdapUser.all.each(&:destroy) }
  
  context "GET /users" do
    before do
      create :ldap_user
      create :admin_ldap_user
      get '/users' 
    end
    subject { last_response }
    
    it { should be_ok }
    its(:body) { should include('user@rubynas.com') }
    its(:body) { should include('admin@rubynas.com') }
    its(:body) { should_not include('userPassword') }
  end
  
  context "POST /users" do
    it "creates a new user" do
      post '/users', :common_name => 'John Doe',
                     :uid => 'jdoe',
                     :home_directory => '/tmp',
                     :gid_number => 1000,
                     :uid_number => 1000,
                     :given_name => "John",
                     :surname => "Doe",
                     :mail => "john.doe@rubynas.com",
                     :password => 'password'
      last_response.status.should == 201
      user = LdapUser.find('John Doe')
      user.should be_a(LdapUser)
      ActiveLdap::UserPassword.valid?('password', 
                                      user.user_password).should be_true
    end

    it "doesn't create a new user if fields are missing" do
      LdapUser.should_not_receive(:create)
      post '/users', :common_name => 'John Doe',
                     :uid => 'jdoe',
                     :home_directory => '/tmp',
                     :gid_number => 1000,
                     :uid_number => 1000
      last_response.should_not be_ok
    end
  end
  
  context "GET /user/cn" do
    it "searches with filter" do
      create :ldap_user
      get '/users/User'
      last_response.should be_ok
    end
  end
  
  context "DELETE /user/cn" do
    it "searches with filter" do
      create :ldap_user
      delete '/users/User'
      last_response.status.should == 200
      expect { LdapUser.find("User") }.to raise_error(ActiveLdap::EntryNotFound)
    end
  end
  
  context "PUT /user/cn" do
    it "updates the user" do
      create :ldap_user
      put '/users/User', :uid_number => 2000
      last_response.should be_ok
    end

    it "updates the user password" do
      create :ldap_user
      put '/users/User', :password => "foobar"
      last_response.should be_ok
      user = LdapUser.find('User')
      ActiveLdap::UserPassword.valid?("foobar", 
                                      user.user_password).should be_true
    end
  end
end