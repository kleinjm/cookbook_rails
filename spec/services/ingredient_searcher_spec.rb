# frozen_string_literal: true

require "rails_helper"

RSpec.describe IngredientSearcher do
  describe "#recipes_with_ingredient" do
    it "returns the recipe with the given ingredient without duplicates" do
      recipe = create :recipe
      first_ingredient = Ingredient.create(name: "chicken fat")
      second_ingredient = Ingredient.create(name: "chicken bones")
      recipe.ingredients = [first_ingredient, second_ingredient]

      results =
        IngredientSearcher.new(query: "chicken").recipes_with_ingredient

      expect(results.count).to eq 1
      expect(results.first).to eq recipe
    end
  end
end
