# frozen_string_literal: true

module Mutations
  class AddIngredientsToWunderlist < Mutations::BaseMutation
    argument :recipe_id, ID, required: true, loads: Types::RecipeType
    argument :multiplier, Float, required: false, default_value: 1

    field :recipe, Types::RecipeType, null: true

    def resolve(recipe:, multiplier:)
      # TODO: look at response
      WunderlistInterface.new.add_recipe(recipe: recipe, multiplier: multiplier)

      MutationResult.call(recipe)
    end
  end
end
