Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :refuges, only: :index do
        resources :entities, only: :index
      end
    end
  end

end
