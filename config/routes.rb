HackathonClient::Application.routes.draw do
  # =================================================
  # The only HTML served by Rails
  # =================================================
  root :to => 'home#index'
  resources :home, :only => [:index]

  # Pusher endpoint
  match 'pusher/auth/:player_name' => 'Pusher#auth', :format => "json"
end
