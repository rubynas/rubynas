require 'spec_helper'

describe SystemInformationAPI do
  include Rack::Test::Methods

  def app
    described_class
  end
  
  describe "GET /system/information" do
    before do
      Sys::Uptime.stub(:boot_time).and_return(Time.gm(2000))
      get '/system/information' 
    end
    subject { last_response }
    
    it { should be_ok }
    its(:body) { should include(Time.gm(2000).to_s) }
  end
end
