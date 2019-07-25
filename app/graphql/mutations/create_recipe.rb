# frozen_string_literal: true

module Mutations
  class CreateRecipe < Mutations::BaseMutation
    argument :name, String, required: true

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

    def resolve(**args)
      authorize_user

      builder = RecipeBuilder.new
      args[:user] = context[:current_user]
      result = builder.create(attributes: args)

      MutationResult.call(
        result[:recipe],
        success: result[:success],
        errors: result[:errors]
      )
    end
  end
end
