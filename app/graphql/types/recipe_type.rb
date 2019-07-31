# frozen_string_literal: true

# Tested in create_recipe_spec
module Types
  class RecipeType < Types::BaseObject
    implements GraphQL::Relay::Node.interface
    global_id_field :id

    field :uuid, ID, null: false
    field :cook_time_quantity, String, null: true
    field :cook_time_unit, String, null: true
    field :description, String, null: true
    field :link, String, null: true
    field :name, String, null: false
    field :description, String, null: true
    field :source, String, null: true
    field :step_list, [String], null: true
    field :steps, String, null: true
    field :cooked_at_dates, [GraphQL::Types::ISO8601DateTime], null: true
    field :up_next, Float, null: false
    field :user, Types::UserType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

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
