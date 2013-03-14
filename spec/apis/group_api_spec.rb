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
end
