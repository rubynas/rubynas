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
  
  context "GET /volumes/:id" do
    context "with volume" do
      before do
        create :root_volume
        get '/volumes/1' 
      end
      subject { last_response }
    
      it { should be_ok }
      its(:body) { should include('/') }
      its(:body) { should include('System Volume') }
    end
    
    context "without volume" do
      before do
        get '/volumes/123123' 
      end
      subject { last_response }
    
      its(:status) { should == 404 }
    end
  end
  
  context "PUT /volumes/:id" do
    context "with volume" do
      before do
        create :root_volume
        put '/volumes/1', name: "Foo"
      end
      subject { last_response }
    
      it { should be_ok }
      specify { Volume.find(1).name.should == "Foo" }
    end
    
    context "without volume" do
      before do
        put '/volumes/123123', name: "Foo"
      end
      subject { last_response }
    
      its(:status) { should == 404 }
    end
  end
  
  context "POST /volumes/:id" do
    before do
      post '/volumes', name: "Foo", path: "/"
    end
    subject { last_response }
  
    its(:status) { should == 201 }
    specify { Volume.where(name: "Foo").should have(1).item }
  end
end
