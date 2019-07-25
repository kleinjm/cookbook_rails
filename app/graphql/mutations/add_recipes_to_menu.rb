# frozen_string_literal: true

module Mutations
  class AddRecipesToMenu < Mutations::BaseMutation
    argument :menu_id, ID, required: true, loads: Types::MenuType
    argument :recipe_ids, [ID], required: true, loads: Types::RecipeType

    field :menu, Types::MenuType, null: true

    def resolve(menu:, recipes:)
      # only add here, do not assign
      recipes.each do |recipe|
        menu.recipes << recipe unless menu.recipes.include?(recipe)
      end

      MutationResult.call(menu)
    end
  end
end
