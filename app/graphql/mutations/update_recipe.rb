# frozen_string_literal: true

module Mutations
  class UpdateRecipe < Mutations::BaseMutation
    argument :recipe_id, ID, required: true, loads: Types::RecipeType

    argument :cook_time_quantity, String, required: false
    argument :cook_time_unit, String, required: false
    argument :ingredients, String, required: false
    argument :link, String, required: false
    argument :name, String, required: false
    argument :description, String, required: false
    argument :source, String, required: false
    argument :steps, String, required: false
    argument :tag_ids, [ID], required: false
    argument :up_next, Float, required: false
    argument :times_cooked, Integer, required: false

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
