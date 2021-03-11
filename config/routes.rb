Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  resources :events, only: [:index] do
    collection do
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
