require 'spec_helper'

describe 'Restful Volume API' do
  include Rack::Test::Methods

  def app
    VolumeAPI
  end
  
  context "GET /volumes" do
    before do
      create :root_volume
      get '/volumes' 
    end
    subject { last_response }
    
    it { should be_ok }
    its(:body) { should include('/') }
    its(:body) { should include('System Volume') }
  end
end
