# frozen_string_literal: true

module Types
  class TagGroupType < Types::BaseObject
    graphql_name "TagGroup"

    implements GraphQL::Types::Relay::Node
    global_id_field :id

    field :id, ID, null: false
    field :uuid, ID, null: false
    field :name, String, null: false
    field :tags, Types::TagType.connection_type, null: true
  end
end
