class MainController < ApplicationController
  layout false
  before_filter :authenticate_user!
  
  def index
    admin_app = Rails.root.join('public', 'index.html')
    if File.exists? admin_app
      render file: admin_app
    else
      render text: "Cannot find #{admin_app}, please run 'git submodule update --init'"
    end
  end
end
