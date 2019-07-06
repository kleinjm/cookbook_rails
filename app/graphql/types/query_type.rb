# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "The query root of this schema"

    # TODO: remove me
    field :users,
          [Types::UserType],
          null: false,
          description: "An example field added by the generator"
    def users
      User.all
    end

    # Used by Relay to lookup objects by UUID
    field :node, field: GraphQL::Relay::Node.field

    # Fetches a list of objects given a list of IDs
    field :nodes, field: GraphQL::Relay::Node.plural_field
  end
end
