class Types::EventType < GraphQL::Schema::Object
  graphql_name 'Event'

  field :id, ID, null: false
  field :user, Types::UserType, null: false
  field :speaker_id, ID, null: false
  field :speaker, Types::UserType, null: false
  field :attendees, [Types::UserType], null: true
  field :kind, Types::EventKind, null: false
  field :date, GraphQL::Types::ISO8601DateTime, null: false
  field :start_at, GraphQL::Types::ISO8601DateTime, null: false
  field :end_at, GraphQL::Types::ISO8601DateTime, null: false
  field :name, String, null: false
  field :location, String, null: false
  field :description, String, null: true
  field :limit, Integer, null: true
  field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
end
