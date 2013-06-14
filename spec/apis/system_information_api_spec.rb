require 'spec_helper'

describe SystemInformationApi do
  include Rack::Test::Methods

  def app
    described_class
  end
  
  describe "GET /vmstat" do
    before do
      get '/vmstat'
    end
    subject { last_response }
    
    it { should be_ok }
  end
  
  describe "GET /disk/" do
    before do
      get '/disk/' 
    end
    subject { last_response }
    
    it { should be_ok }
  end
end
