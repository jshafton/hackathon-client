HackathonClient::Application.routes.draw do
  # =================================================
  # The only HTML served by Rails
  # =================================================
  root :to => 'home#index'
  resources :home, :only => [:index]
end
