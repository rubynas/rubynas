class MainController < ApplicationController
  layout false
  before_filter :authenticate_user!
  
  def index
    render file: Rails.root.join('public', 'index.html')
  end
end
