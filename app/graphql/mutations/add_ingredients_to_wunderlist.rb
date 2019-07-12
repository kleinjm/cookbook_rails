# frozen_string_literal: true

module Mutations
  class AddIngredientsToWunderlist < Mutations::BaseMutation
    argument :recipe_id, ID, required: true, loads: Types::RecipeType
    argument :multiplier, Float, required: false, default_value: 1

    field :task_count, Integer, null: true
    field :errors, [String], null: false

    def resolve(recipe:, multiplier:)
      task_count = WunderlistInterface.new.add_recipe(
        recipe: recipe, multiplier: multiplier
      )
      {
        task_count: task_count,
        errors: ["There was an issue adding ingredients to wunderlist"]
      }
    end
  end
end
