Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'document#index'
  resources :document, except: [:delete] do
    get 'download'
    get 'user'
    get 'search', on: :collection
  end

  devise_for :users
  devise_for :managers

end
