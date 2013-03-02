require 'spec_helper'

describe MainController do
  describe "GET 'index'" do
    let(:user) { create :user }
    
    it "returns http success" do
      sign_in user
      get 'index'
      response.should be_success
    end
    
    it "redirects to devise for authetication" do
      get 'index'
      response.should redirect_to('/users/sign_in')
    end
  end
end
