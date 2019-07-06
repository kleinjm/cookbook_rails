# frozen_string_literal: true

class CookbookRailsSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # GraphQL::Batch setup:
  use GraphQL::Batch
end
