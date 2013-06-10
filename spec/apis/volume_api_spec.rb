require 'spec_helper'

describe 'Restful Volume API' do
  include Rack::Test::Methods

  def app
    VolumeAPI
  end

  context "GET /" do
    before do
      create :root_volume
      get '/'
    end
    subject { last_response }

    it { should be_ok }
    its(:body) { should include('/') }
    its(:body) { should include('System Volume') }
  end

  context "GET /:id" do
    context "with volume" do
      before do
        create :root_volume
        get '/1'
      end
      subject { last_response }

      it { should be_ok }
      its(:body) { should include('/') }
      its(:body) { should include('System Volume') }
    end

    context "without volume" do
      before do
        get '/123123'
      end
      subject { last_response }

      its(:status) { should == 404 }
    end
  end

  context "PUT /:id" do
    context "with volume" do
      before do
        create :root_volume
        put '/1', name: "Foo"
      end
      subject { last_response }

      it { should be_ok }
      specify { Volume.find(1).name.should == "Foo" }
    end

    context "without volume" do
      before do
        put '/123123', name: "Foo"
      end
      subject { last_response }

      its(:status) { should == 404 }
    end
  end

  context "POST /:id" do
    before do
      post '/', name: "Foo", path: "/"
    end
    subject { last_response }

    its(:status) { should == 201 }
    specify { Volume.where(name: "Foo").should have(1).item }
  end

  context "DELETE /:id" do
    context "with volume" do
      before do
        create :root_volume
        delete '/1'
      end
      subject { last_response }

      it { should be_ok }
      specify { Volume.all.should be_empty }
    end

    context "without volume" do
      before do
        delete '/123123'
      end
      subject { last_response }

      its(:status) { should == 404 }
    end
  end
end
