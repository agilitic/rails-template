ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :user_sessions

  map.signup 'signup',
    :controller => 'users',
    :action => 'new'

  map.login 'login',
    :controller => 'user_sessions',
    :action => 'new'

  map.logout 'logout',
    :controller => 'user_sessions',
    :action => 'destroy'

  map.namespace :admin do |admin|
    admin.resources :users
    admin.root :controller => 'users'
  end

  map.root :controller => 'users'
end
