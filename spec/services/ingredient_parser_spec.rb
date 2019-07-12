# frozen_string_literal: true

require "rails_helper"

RSpec.describe IngredientRecipe do
  describe "#assign_to_recipe" do
    it "parses the given ingredients and creates intermediary objects" do
      parser = IngredientParser.
               new(["1 cup parsley", "", "2.5 teaspoons rosemary"])
      recipe = Recipe.new

      expect do
        parser.assign_to_recipe(recipe)
      end.to change(Ingredient, :count).by(2).
        and change(Unit, :count).by(2)

      expect(recipe.ingredients_recipes.size).to eq 2
      expect(recipe.ingredients_recipes.first.order).to eq 0
      expect(recipe.ingredients_recipes.second.order).to eq 1
    end

    it "does not create any extra relationships" do
      recipe = create :recipe
      unit = create :unit, name: "cup"
      parsley = create :ingredient, name: "Parsley"
      cheese = create :ingredient, name: "Cheese"
      eggs = create :ingredient, name: "Eggs"
      create(
        :ingredient_recipe,
        recipe: recipe,
        ingredient: parsley,
        unit: unit,
        quantity: 3,
        order: 0
      )
      create(
        :ingredient_recipe,
        recipe: recipe,
        ingredient: cheese,
        unit: unit,
        quantity: 10,
        order: 1
      )
      create(
        :ingredient_recipe,
        recipe: recipe,
        ingredient: eggs,
        unit: unit,
        quantity: 4,
        order: 2
      )
      # first moves to last. third moves to first. second is removed.
      parser = IngredientParser.new(["4 cups eggs", "1 cup parsley"])

      expect do
        parser.assign_to_recipe(recipe)
        recipe.save
      end.to change(Ingredient, :count).by(0).
        and change(Unit, :count).by(0).
        and change(IngredientRecipe, :count).by(-1) # remove second one

      updated_joins = recipe.ingredients_recipes.by_order
      expect(updated_joins.count).to eq 2
      expect(updated_joins.first.ingredient).to eq eggs
      expect(updated_joins.second.ingredient).to eq parsley
    end

    it "sets joins to empty if no text is provided" do
      # you should be able to clear the field
      recipe = create :recipe
      ingredient = create :ingredient, name: "Parsley"
      create(:ingredient_recipe, recipe: recipe, ingredient: ingredient)
      parser = IngredientParser.new([])

      parser.assign_to_recipe(recipe)

      expect(recipe.ingredients).to eq []
      expect(recipe.ingredients_recipes).to eq []
    end
  end
end
