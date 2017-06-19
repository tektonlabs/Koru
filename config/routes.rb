Rails.application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/tracker', as: 'rails_admin'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :refuges, only: [:index, :create] do
        resources :entities, only: :index
        resources :responses, only: :create
        collection do
          get :multiple_choice_ids
          get :search_committees
        end
      end
    end
  end

  namespace :admin do
    root 'refuges#index'
    resources :questionnaires, only: :index
    resources :refuges, only: [:index, :destroy] do
      resources :questionnaires, only: [:new, :create], controller: "refuges/questionnaires"
    end
    resources :users, only: :index
    resources :census_takers, only: :index
  end

  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do
    namespace :front, path: '' do
      root 'refuges#index'
      resources :refuges, only: [:index, :show] do
        member do
          get :detail
          get :historical_issues_by_entity
        end
        collection do
          get :filter_by
        end
      end
    end
  end

  root to: redirect("#{ENV['RELATIVE_URL_ROOT']}/#{I18n.default_locale}")
  match '*locale/*path', to: redirect("#{ENV['RELATIVE_URL_ROOT']}/#{I18n.default_locale}/%{path}"), via: :all
  match '*path', to: redirect("#{ENV['RELATIVE_URL_ROOT']}/#{I18n.default_locale}/%{path}"), via: :all

end
