Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  mount Blazer::Engine, at: 'blazer'

  namespace :api do
    namespace :v1 do
      # admin
      post '/login', to: 'users#login'
      get '/admin/synonyms', to: 'synonyms#admin_index'
      patch '/admin/synonyms/:id', to: 'synonyms#admin_update'
      delete '/admin/synonyms/:id', to: 'synonyms#admin_destroy'

      # guest user
      resources :synonyms, only: [:index, :create]
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
