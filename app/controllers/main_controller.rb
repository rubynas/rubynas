class MainController < ApplicationController
  layout false
  before_filter :authenticate_user!
  
  def index
    admin_app = Rails.root.join('public', 'index.html')
    if File.exists? admin_app
      render file: admin_app
    else
      render text: "Cannot find #{admin_app}, "\
                   "please initialize the admin app:<br><br>"\
                   "<code>git submodule update --init</code><br><br>"\
                   "and then build the admin app like so:<br><br>"\
                   "<code>cd admin</code><br>"\
                   "<code>npm install</code><br>"\
                   "<code>bower install</code><br>"\
                   "<code>brunch build</code>"
    end
  end
end
