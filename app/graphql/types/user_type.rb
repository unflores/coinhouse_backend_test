class Types::UserType < Types::BaseObject
  graphql_name 'User'

  field :id, ID, null: false
  field :events, [Types::EventType], null: true
  field :speeches, [Types::EventType], null: true
  field :first_name, String, null: false
  field :last_name, String, null: false
  field :email, String, null: false
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end
