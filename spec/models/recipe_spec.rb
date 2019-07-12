# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe do
  describe "relationships" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:images).dependent(:destroy) }
    it { is_expected.to have_many(:ingredients_recipes) }
    it { is_expected.to have_many(:categories_recipes).dependent(:destroy) }
    it do
      is_expected.to have_many(:categories).
        through(:categories_recipes).order(:name)
    end
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to have_many(:categories).
        through(:categories_recipes).order(:name)
    end
    it do
      is_expected.to have_many(:menus_recipes).
        dependent(:destroy).class_name("MenuRecipe")
    end
    it do
      is_expected.to have_many(:menus).through(:menus_recipes)
    end
  end

  it do
    is_expected.to validate_numericality_of(:cook_time_quantity).
      is_greater_than_or_equal_to(0).allow_nil
  end

  describe "#step_list" do
    it "does not break if step_text is blank" do
      expect(Recipe.new.step_list).to eq []
    end
  end

  describe "#ingredients_full_names" do
    it "returns the full names of the ingredients for this recipe" do
      recipe = create :recipe
      ingredient = create :ingredient, name: "Cumin"
      unit = create :unit, name: "cup"
      IngredientRecipe.
        create(ingredient: ingredient, recipe: recipe, unit: unit, quantity: 1)

      expect(recipe.ingredients_full_names).to eq(["1 cup Cumin"])
    end

    it "returns the full names of the ingredients multiplied" do
      recipe = create :recipe
      ingredient = create :ingredient, name: "Cumin"
      unit = create :unit, name: "cup"
      IngredientRecipe.
        create(ingredient: ingredient, recipe: recipe, unit: unit, quantity: 1)

      expect(recipe.ingredients_full_names(multiplier: 2)).
        to eq(["2 cup Cumin"])
    end
  end

  describe ".this_week" do
    it "returns only recipes for this week" do
      this_week_recipe = create :recipe, this_week: 1
      create :recipe, this_week: 0
      expect(Recipe.this_week).to contain_exactly(this_week_recipe)
    end
  end

  describe ".reset_this_week" do
    it "makes all recipe this_week false" do
      recipe = create :recipe, this_week: 1
      Recipe.reset_this_week
      expect(recipe.reload.this_week).to eq(0)
    end
  end

  describe "#steps_count" do
    it "returns the correct step count" do
      recipe = Recipe.new(step_text: "first\n second")
      expect(recipe.steps_count).to eq 2
    end
  end
end
