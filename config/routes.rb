Rails.application.routes.draw do

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
  end

  post "/graphql", to: "graphql#execute"

  scope :api do
    resources :events, only: [:index, :create] do
      collection do
      end
    end
    resources :users, only: [:new, :create] do
      collection do
      end
    end
  end

  post 'login', to: 'sessions#create'
end
