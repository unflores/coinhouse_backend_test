Rails.application.routes.draw do

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
  end

  post "/graphql", to: "graphql#execute"

  resources :events, only: [:index, :create] do
    collection do
    end
  end

  resources :users, only: [:create] do
    collection do
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
