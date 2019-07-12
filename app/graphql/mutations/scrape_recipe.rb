# frozen_string_literal: true

module Mutations
  class ScrapeRecipe < Mutations::BaseMutation
    argument :recipe_id, ID, required: false
    argument :url, String, required: true

    field :recipe, Types::RecipeType, null: true
    field :errors, [String], null: false

    def resolve(**args)
      recipe = find_recipe(args[:recipe_id])
      scraper = RecipeScraper.new(recipe)
      result = scraper.scrape(args[:url])
      {
        recipe: scraper.recipe,
        errors: Array(result.errors)
      }
    end

    def find_recipe(recipe_id)
      recipe_id.present? ? Recipe.find_by(gql_id: recipe_id) : Recipe.new
    end
  end
end
