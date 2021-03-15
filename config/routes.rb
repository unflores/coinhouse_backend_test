Rails.application.routes.draw do

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
  end
  post "/graphql", to: "graphql#execute"

  scope :api do
    resources :events, only: [:index, :create] do
      post :attend
      post :unregister
      collection do
        post :attend
        post :unregister
      end
    end
    resources :users, only: [:new, :create]
    post 'login', to: 'sessions#create'
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"
end
