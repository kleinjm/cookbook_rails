# frozen_string_literal: true

module Mutations
  class UpdateCookedAtDates < Mutations::BaseMutation
    argument :recipe_uuid, ID, required: true
    argument :amount, Integer, required: true

    field :recipe, Types::RecipeType, null: true

    def resolve(**args)
      recipe = Recipe.find(args[:recipe_uuid])
      authorize_for_object(recipe)

      result = CookedAtDateChanger.
               new(recipe: recipe, amount: args[:amount]).call

      MutationResult.call(
        result[:recipe],
        success: result[:success],
        errors: result[:errors]
      )
    end
  end
end
