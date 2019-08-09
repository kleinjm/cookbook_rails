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

    it "syncs the tags" do
      builder = RecipeBuilder.new
      tag = create(:tag)
      user = create(:user)

      response = builder.create(
        attributes: {
          name: "Test",
          user_id: user.id,
          tag_ids: [tag.id],
          steps: "  leading space\nAnd end space\n"
        }
      )

      expect(response[:success]).to eq(true)
      expect(response[:errors]).to be_blank

      recipe = Recipe.first
      expect(recipe.name).to eq("Test")
      expect(recipe.user).to eq(user)
      expect(recipe.tags).to eq([tag])
      expect(recipe.steps).to eq("leading space\nAnd end space\n")
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
