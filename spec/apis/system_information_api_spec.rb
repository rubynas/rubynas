require 'spec_helper'

describe SystemInformationAPI do
  include Rack::Test::Methods

  def app
    described_class
  end
  
  describe "GET /system/vmstat" do
    before do
      get '/system/vmstat'
    end
    subject { last_response }
    
    it { should be_ok }
  end
  
  describe "GET /system/disk/" do
    before do
      get '/system/disk/' 
    end
    subject { last_response }
    
    it { should be_ok }
  end
end
