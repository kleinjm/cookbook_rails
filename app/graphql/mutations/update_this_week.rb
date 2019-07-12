# frozen_string_literal: true

module Mutations
  class UpdateThisWeek < Mutations::BaseMutation
    argument :recipe_ids, [ID], required: false
    argument :this_week, Float, required: true

    field :recipes, [Types::RecipeType], null: true

    def resolve(**args)
      recipes = Recipe.find_by(gql_ids: args[:recipe_ids])
      authorize_for_objects(recipes)

      success = recipes.update(this_week: args[:this_week])

      MutationResult.call(
        obj: { recipes: recipes },
        success: success,
        errors: recipes.map(&:errors).flatten
      )
    end
  end
end
