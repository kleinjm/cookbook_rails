# frozen_string_literal: true

module Mutations
  class UpdateUpNext < Mutations::BaseMutation
    argument :recipe_ids, [ID], required: false
    argument :up_next, Float, required: true

    field :recipes, [Types::RecipeType], null: true

    def resolve(**args)
      recipes = Recipe.find_by_gql_ids(args[:recipe_ids])
      authorize_for_objects(recipes)

      recipes.update(up_next: args[:up_next])

      MutationResult.call(
        recipes,
        success: true,
        errors: recipes.map { |recipe| recipe.errors&.full_messages }.flatten
      )
    end
  end
end
