# frozen_string_literal: true

require "rails_helper"

RSpec.describe Queries::Recipes do
  describe ".call" do
    it "returns no recipes if not signed in" do
      create(:recipe)
      recipes = described_class.call

      expect(recipes.count).to be_zero
    end

    it "returns all recipes for only the given user" do
      my_user = create(:user)
      my_recipe = create(:recipe, user: my_user)

      other_user = create(:user)
      _other_recipe = create(:recipe, user: other_user)

      recipes = described_class.call(user: my_user)

      expect(recipes.count).to eq(1)
      expect(recipes.first).to eq(my_recipe)
    end

    it "returns recipes matching tag ids" do
      tag = create(:tag)
      recipe = create(:recipe)
      recipe.tags << tag
      _not_included = create(:recipe)

      recipes = described_class.
                call(tag_ids: [tag.id], user: recipe.user)

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
    end

    it "returns recipes matching search query" do
      user = create(:user)
      _not_matched = create(:recipe, name: "cold digs", user: user)
      recipe = create(:recipe, name: "hot dogs", user: user)

      recipes = described_class.call(search_query: "dog", user: user)

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
    end

    it "returns n last cooked recipes" do
      user = create(:user)
      recipe = create(:recipe, last_cooked: Time.current, user: user)
      _not_matched = create(:recipe, last_cooked: 1.week.ago, user: user)

      recipes = described_class.call(last_cooked: 1, user: user)

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
    end

    it "returns up_next recipes if up_next true" do
      user = create(:user)
      recipe = create(:recipe, up_next: 1, user: user)
      _not_up_next = create(:recipe, up_next: 0, user: user)

      recipes = described_class.call(up_next: true, user: user)

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
      expect(recipes.first.up_next).to eq(1.0)
    end

    it "returns recipes with the matched ingredient names" do
      recipe = create :recipe
      first_ingredient = Ingredient.create(name: "chicken fat")
      second_ingredient = Ingredient.create(name: "chicken bones")
      recipe.ingredients = [first_ingredient, second_ingredient]

      recipes = described_class.call(
        ingredient_search: "chicken", user: recipe.user
      )

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
    end
  end
end
