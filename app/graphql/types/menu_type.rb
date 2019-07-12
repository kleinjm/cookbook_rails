# frozen_string_literal: true

module Types
  class MenuType < Types::BaseObject
    graphql_name "Menu"

    implements GraphQL::Types::Relay::Node
    global_id_field :id

    field :name, String, null: false
    field :description, String, null: true
    field :recipes, [RecipeType], "Recipes for this menu", null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    delegate :recipes, to: :object
  end
end
