Rubynas::Application.routes.draw do
  # application authentication
  devise_for :users

  # api's that are called by the javascript application and others
  mount UserAPI => '/api'
  mount GroupAPI => '/api'
  mount VolumeAPI => '/api'
  mount SystemInformationAPI => '/api'
  
  # fallback route everything will be routed to the index page. Since we use
  # the angular html histroy api a refresh will be called on a real resource
  # every time the user makes a refresh. By rendeing the main index the app
  # can pick up the path an show the correct page.
  match '*path' => 'main#index'
  root :to => 'main#index'
end
