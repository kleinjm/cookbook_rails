# frozen_string_literal: true

module Types
  class RecipeType < Types::BaseObject
    implements GraphQL::Relay::Node.interface
    global_id_field :id

    field :name, String, null: false
    field :times_cooked, Integer, null: false
    field :link, String, null: true
    field :description, String, null: true
    field :steps, String, null: true
    field :step_list, [String], null: true
    field :source, String, null: true
    field :up_next, Float, null: false
    field :last_cooked, GraphQL::Types::ISO8601DateTime, null: true
    field :user, Types::UserType, null: true

    field :tags, TagType.connection_type, null: false
    delegate :tags, to: :object

    field :ingredients,
          IngredientRecipeType.connection_type,
          "Join between ingredient and recipe exposed as the ingredient " \
          "with accessor fields",
          null: false
    def ingredients
      object.ingredients_recipes_including_relations
    end
  end
end
