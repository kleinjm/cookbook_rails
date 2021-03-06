# frozen_string_literal: true

module Types
  class TagType < Types::BaseObject
    graphql_name "Tag"

    implements GraphQL::Types::Relay::Node
    global_id_field :id

    field :id, ID, null: false
    field :name, String, null: false
  end
end
