Spree::Core::Engine.routes.draw do
  resources :orders do
    resources :return_authorizations, only: [:new, :create, :show]
  end
  resources :return_authorizations, only: :index
end
