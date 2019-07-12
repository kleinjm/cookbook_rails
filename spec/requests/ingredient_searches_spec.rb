# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Ingredient seraches endpoints" do
  describe "/ingredient_search" do
    it "responds to html successfully" do
      get ingredient_search_index_path
      expect(response).to be_successful
    end

    context "json" do
      it "responds with the searched recipes" do
        recipe = create :recipe, :with_ingredient
        ingredient_name = recipe.ingredients.first.name

        get ingredient_search_index_path(format: :json, query: ingredient_name)

        expect(response).to be_successful
        expect(json_body.count).to eq 1
        expect(json_body.first["id"]).to eq recipe.id
      end
    end
  end
end
