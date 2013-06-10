require 'spec_helper'

describe 'Restful User API' do
  include Rack::Test::Methods

  def app
    UserAPI
  end
  
  before { LdapUser.all.each(&:destroy) }
  
  context "GET /" do
    before do
      create :ldap_user
      create :admin_ldap_user
      get '/' 
    end
    subject { last_response }
    
    it { should be_ok }
    its(:body) { should include('user@rubynas.com') }
    its(:body) { should include('admin@rubynas.com') }
    its(:body) { should_not include('userPassword') }
  end
  
  context "GET /template" do
    before do
      get '/template'
    end
    subject { last_response }

    it { should be_ok }
    its(:body) { should include('1000') }
    its(:body) { should include('/home/') }

    context "with one user" do
      before do
        create :ldap_user
        get '/template' 
      end
      subject { last_response }

      it { should be_ok }
      its(:body) { should include('1001') }
      its(:body) { should include('/home/') }
      its(:body) { should include('1000') } # group
    end
  end

  context "POST /" do
    it "creates a new user" do
      post '/', :common_name => 'John Doe',
                     :uid => 'jdoe',
                     :home_directory => '/tmp',
                     :gid_number => 1000,
                     :uid_number => 1000,
                     :given_name => "John",
                     :surname => "Doe",
                     :mail => "john.doe@rubynas.com",
                     :password => 'password',
                     :login_shell => '/bin/bash'
      last_response.status.should == 201
      user = LdapUser.find('John Doe')
      user.should be_a(LdapUser)
      ActiveLdap::UserPassword.valid?('password', 
                                      user.user_password).should be_true
    end

    it "doesn't create a new user if fields are missing" do
      LdapUser.should_not_receive(:create)
      post '/', :common_name => 'John Doe',
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
      get '/User'
      last_response.should be_ok
    end
  end
  
  context "DELETE /user/cn" do
    it "searches with filter" do
      create :ldap_user
      delete '/User'
      last_response.status.should == 200
      expect { LdapUser.find("User") }.to raise_error(ActiveLdap::EntryNotFound)
    end
  end
  
  context "PUT /user/cn" do
    it "updates the user" do
      create :ldap_user
      put '/User', :uid_number => 2000
      last_response.should be_ok
    end

    it "updates the user password" do
      create :ldap_user
      put '/User', :password => "foobar"
      last_response.should be_ok
      user = LdapUser.find('User')
      ActiveLdap::UserPassword.valid?("foobar", 
                                      user.user_password).should be_true
    end
  end
end