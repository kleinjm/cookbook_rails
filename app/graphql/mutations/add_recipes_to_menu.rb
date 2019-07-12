# frozen_string_literal: true

module Mutations
  class AddRecipesToMenu < Mutations::BaseMutation
    argument :menu_id, ID, required: true, loads: Types::MenuType
    argument :recipe_ids, [ID], required: true, loads: Types::RecipeType

    field :errors, [String], null: false

    def resolve(menu:, recipes:)
      recipes.each do |recipe|
        menu.recipes << recipe unless menu.recipes.include?(recipe)
      end

      {
        errors: []
      }
    end
  end
end
