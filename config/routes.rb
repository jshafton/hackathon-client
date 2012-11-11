HackathonClient::Application.routes.draw do
  # =================================================
  # The only HTML served by Rails
  # =================================================
  root :to => 'home#index'
  resources :home, :only => [:index]

  # Pusher endpoint
  match 'pusher/auth' => 'Pusher#auth', :format => "json"
  match 'pusher/auth_jsonp' => 'Pusher#auth_jsonp', :format => "json"
end
