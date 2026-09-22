Rails.application.routes.draw do
  resources :rooms, only: [:index, :show, :new, :create]

  resources :reservations, only: [:new, :create, :edit, :update]
  root "rooms#index"
end
