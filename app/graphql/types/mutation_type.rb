# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :add_ingredients_to_wunderlist,
          mutation: Mutations::AddIngredientsToWunderlist
    field :add_recipes_to_menu, mutation: Mutations::AddRecipesToMenu
    field :create_menu, mutation: Mutations::CreateMenu
    field :create_recipe, mutation: Mutations::CreateRecipe
    field :create_tag, mutation: Mutations::CreateTag
    field :delete_menu, mutation: Mutations::DeleteMenu
    field :delete_recipe, mutation: Mutations::DeleteRecipe
    field :delete_tag, mutation: Mutations::DeleteTag
    field :scrape_recipe, mutation: Mutations::ScrapeRecipe
    field :update_menu, mutation: Mutations::UpdateMenu
    field :update_recipe, mutation: Mutations::UpdateRecipe
    field :update_tag, mutation: Mutations::UpdateTag
    field :update_up_next, mutation: Mutations::UpdateUpNext
  end
end
