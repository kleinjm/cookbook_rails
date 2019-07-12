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
                call(tag_ids: [tag.gql_id], user: recipe.user)

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
    end

    it "returns recipes matching category ids" do
      user = create(:user)
      category = create(:category)
      recipe = create(:recipe, user: user)
      recipe.categories << category
      _not_included = create(:recipe, user: user)

      recipes = described_class.call(
        category_ids: [category.gql_id], user: user
      )

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
    end

    it "returns recipes matching category and tag ids" do
      user = create(:user)

      tag = create(:tag)
      category = create(:category)
      _not_included = create(:recipe, user: user)

      recipe = create(:recipe, user: user)
      recipe.categories << category
      recipe.tags << tag

      recipes = described_class.call(
        category_ids: [category.gql_id], tag_ids: [tag.gql_id], user: user
      )

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

    it "returns this_week recipes if this_week true" do
      user = create(:user)
      recipe = create(:recipe, this_week: 1, user: user)
      _not_this_week = create(:recipe, this_week: 0, user: user)

      recipes = described_class.call(this_week: true, user: user)

      expect(recipes.length).to eq(1)
      expect(recipes.first).to eq(recipe)
      expect(recipes.first.this_week).to eq(1.0)
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
