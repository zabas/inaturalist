ActionController::Routing::Routes.draw do |map|

  simplified_login_regex = /\w[^\.,\/]+/
  
  map.root :controller => 'welcome', :action => 'index'
  map.resources :users
  map.resource :session
  map.resources :passwords
  
  map.resources :observation_photos, :only => :create
  map.observation_photos_ping 'observation_photos/ping.:format', :controller => 'observation_photos', :action => 'ping'

  # Default route
  map.connect ':controller/:action/:id'
end
