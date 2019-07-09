# frozen_string_literal: true

module Mutations
  class CreateRecipe < Mutations::BaseMutation
    argument :name, String, required: true

    # argument :category_ids, [ID], required: false
    argument :ingredients, String, required: false
    argument :link, String, required: false
    argument :notes, String, required: false
    argument :source, String, required: false
    argument :step_text, String, required: false
    # argument :tag_ids, [ID], required: false
    argument :this_week, Float, required: false
    argument :times_cooked, Integer, required: false

    field :recipe, Types::RecipeType, null: true

    def resolve(**args)
      authorize_user

      builder = RecipeBuilder.new
      args[:user] = context[:current_user]
      result = builder.create(attributes: args)

      MutationResult.call(
        obj: { recipe: builder.recipe },
        success: result.success,
        errors: result.errors
      )
    end
  end
end
