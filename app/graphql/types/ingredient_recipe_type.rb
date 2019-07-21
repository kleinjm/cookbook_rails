# frozen_string_literal: true

module Types
  class IngredientRecipeType < Types::BaseObject
    implements GraphQL::Types::Relay::Node
    global_id_field :id

    field :quantity, Float, null: true
    field :unit, String, "Name of the related unit", null: true
    def unit
      object.unit&.name
    end

    field :name, String, "Name of the related ingredient", null: false
    def name
      object.ingredient.name
    end
  end
end
