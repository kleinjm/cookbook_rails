# frozen_string_literal: true

module Types
  class TagType < Types::BaseObject
    graphql_name "Tag"

    implements GraphQL::Types::Relay::Node
    global_id_field :id

    field :id, ID, null: false
    field :name, String, null: false
    field :recipe_count, Integer, null: false

    def recipe_count
      object.recipes.count
    end
  end
end
