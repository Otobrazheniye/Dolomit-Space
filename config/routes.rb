Rails.application.routes.draw do
  resources :rooms, only: [:index, :show, :new, :create]

  root "rooms#index"
end
