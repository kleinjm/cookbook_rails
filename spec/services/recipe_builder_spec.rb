# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipeBuilder do
  describe "#create" do
    it "handle standard errors" do
      builder = RecipeBuilder.new
      allow(builder).to receive(:clean_attributes).and_raise("ERROR!")

      response = builder.create(attributes: {})

      expect(response[:success]).to eq false
      expect(response[:errors]).to eq ["Error modifying recipe", "ERROR!"]
    end
  end

  describe "#update" do
    it "updates the name and link" do
      recipe = create :recipe
      attributes =
        { name: "new name", link: "http://google.com" }.with_indifferent_access

      RecipeBuilder.new(recipe.id).update(attributes: attributes)
      recipe.reload

      expect(recipe.name).to eq "New Name"
      expect(recipe.link).to eq attributes[:link]
    end

    it "handle standard errors" do
      builder = RecipeBuilder.new
      allow(builder).to receive(:clean_attributes).and_raise("ERROR!")

      response = builder.update(attributes: {})

      expect(response[:success]).to eq false
      expect(response[:errors]).to eq ["Error modifying recipe", "ERROR!"]
    end
  end
end
