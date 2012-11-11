HackathonClient::Application.routes.draw do
  # =================================================
  # The only HTML served by Rails
  # =================================================
  root :to => 'home#index'
  resources :home, :only => [:index]

  # Pusher endpoint
  match 'pusher/auth/:player_name' => 'Pusher#auth', :format => "json"
  match 'pusher/auth/:player_name/:player_email' => 'Pusher#auth_jsonp', :format => "json"
  match 'pusher/auth_jsonp/:player_name' => 'Pusher#auth_jsonp', :format => "json"
  match 'pusher/auth_jsonp/:player_name/:player_email' => 'Pusher#auth_jsonp', :format => "json"
end
