class ApplicationController < ActionController::Base
  before_filter :authenticate_member!
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  protect_from_forgery
end
