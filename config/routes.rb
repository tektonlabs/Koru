# <!--

# =========================================================================== 
# Koru GPL Source Code 
# Copyright (C) 2017 Tekton Labs
# This file is part of the Koru GPL Source Code.
# Koru Source Code is free software: you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version. 

# Koru Source Code is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details. 

# You should have received a copy of the GNU General Public License 
# along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
# =========================================================================== 

# */

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
          get :generate_summary
        end
        collection do
          get :filter_by
          get :search_by
        end
        resources :needs, only: [] do
          resources :assignments, only: [:new, :create], controller: "refuges/needs/assignments"
        end
      end
    end
  end

  root to: redirect("#{ENV['HOST']}#{ENV['RELATIVE_URL_ROOT']}#{I18n.default_locale}")

end
