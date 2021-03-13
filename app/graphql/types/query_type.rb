module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :fetch_events, resolver: Queries::FetchEvents
    field :fetch_event, resolver: Queries::FetchEvent

    field :fetch_users, resolver: Queries::FetchUsers
  end
end
