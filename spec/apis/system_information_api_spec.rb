require 'spec_helper'

describe SystemInformationApi do
  include Rack::Test::Methods

  def app
    described_class
  end

  describe "GET /vmstat" do
    before { get '/vmstat' }
    subject { last_response }

    it { should be_ok }
  end

  describe "GET /disk/" do
    before { get '/disk/' }
    subject { last_response }

    it { should be_ok }
  end

  describe "GET /hostname" do
    before { get '/hostname' }
    subject { last_response }

    it { should be_ok }
  end
end
