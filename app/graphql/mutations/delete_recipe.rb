# frozen_string_literal: true

module Mutations
  class DeleteRecipe < Mutations::BaseMutation
    argument :recipe_id, ID, required: true, loads: Types::RecipeType

    field :recipe, Types::RecipeType, null: true

    def resolve(recipe:)
      authorize_for_object(recipe)

      recipe.destroy
      MutationResult.call(
        obj: { recipe: recipe },
        errors: recipe.errors.full_messages
      )
    end
  end
end
