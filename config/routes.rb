Rails.application.routes.draw do

  root 'refuges#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :refuges, only: :index do
        resources :entities, only: :index
        resources :responses, only: :create
      end
    end
  end

  resources :refuges, only: :index

end
