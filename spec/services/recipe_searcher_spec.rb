# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipeSearcher do
  describe "#call" do
    it "filters on tags" do
      tag_one = create(:tag)
      recipe_one = create(:recipe)
      recipe_one.tags << tag_one

      tag_two = create(:tag)
      recipe_two = create(:recipe)
      recipe_two.tags << tag_two

      results = described_class.new(tag_gql_ids: [tag_one.gql_id]).call

      expect(results).to eq([recipe_one])
    end

    it "filters on categories" do
      category_one = create(:category)
      recipe_one = create(:recipe)
      recipe_one.categories << category_one

      category_two = create(:category)
      recipe_two = create(:recipe)
      recipe_two.categories << category_two

      results = described_class.new(category_gql_ids: [category_one.gql_id]).
                call

      expect(results).to eq([recipe_one])
    end
  end
end
