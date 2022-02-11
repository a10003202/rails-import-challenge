Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root to: 'sessions#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  get 'forgot_password' => 'sessions#forgot_password'
  post 'forgot_password' => 'sessions#recover_password'

  resources :galleries do
    collection do
      get 'get_by_owner' => 'galleries#get_by_owner'
      post 'create_images' => 'galleries#create_images'
      put 'order_images' => 'galleries#order_images'
      delete 'destroy_images' => 'galleries#destroy_images'
    end
  end
  namespace :admin do
    get 'home' => 'home#index'
    resources :home do
      collection do
        post 'import_purchases' => 'home#import_purchases'
        get 'import_example' => 'home#download_import_example'
      end
    end
    resources :users do
      collection do
        get 'search' => 'users#search'
      end
    end
  end
  namespace :api, path: '/', defaults: {format: :json} do
    namespace :v1 do
      resources :authorizations do
        collection do
          post 'login' => 'authorizations#login'
          post 'logout' => 'authorizations#logout'
          post 'forgot_password' => 'authorizations#forgot_password'
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
