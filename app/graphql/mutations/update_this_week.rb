# frozen_string_literal: true

module Mutations
  class UpdateThisWeek < Mutations::BaseMutation
    argument :recipe_ids, [ID], required: false
    argument :up_next, Float, required: true

    field :recipes, [Types::RecipeType], null: true

    def resolve(**args)
      recipes = Recipe.find_by_gql_ids(args[:recipe_ids])
      authorize_for_objects(recipes)

      success = recipes.update(up_next: args[:up_next])

      MutationResult.call(
        recipes,
        success: success,
        errors: recipes.map(&:errors).flatten
      )
    end
  end
end
