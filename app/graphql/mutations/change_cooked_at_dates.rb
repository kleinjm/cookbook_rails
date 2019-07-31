# frozen_string_literal: true

module Mutations
  class ChangeCookedAtDates < Mutations::BaseMutation
    argument :recipe_id, ID, required: true, loads: Types::RecipeType

    argument :change_amount, Int, required: true

    field :recipe, Types::RecipeType, null: true

    def resolve(recipe:, **args)
      authorize_for_object(recipe)

      # TODO: update RecipeBuilder to take in an instance of a recipe
      builder = RecipeBuilder.new(recipe.id)
      result = builder.update(attributes: args)

      MutationResult.call(
        result[:recipe],
        success: result[:success],
        errors: result[:errors]&.full_messages
      )
    end
  end
end
