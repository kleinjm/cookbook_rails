# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecipeBuilder do
  describe "#create" do
    it "handle standard errors" do
      builder = RecipeBuilder.new
      allow(builder).to receive(:clean_attributes).and_raise("ERROR!")

      response = builder.create(attributes: {})

      expect(response.success).to eq false
      expect(response.errors).to eq ["Error modifying recipe", "ERROR!"]
    end
  end

  describe "#update" do
    it "updates the name and link" do
      recipe = create :recipe
      attributes =
        { name: "new name", link: "new link" }.with_indifferent_access
      RecipeBuilder.new(recipe.id).update(attributes: attributes)
      recipe.reload
      expect(recipe.name).to eq "New Name"
      expect(recipe.link).to eq attributes[:link]
    end

    it "updates the categories" do
      recipe = create :recipe
      original_category = create :category
      recipe.categories << original_category
      new_category = create :category

      builder = RecipeBuilder.new(recipe.id)
      builder.update(attributes: { categories: [{ id: new_category.id }] })
      recipe.reload
      expect(recipe.categories).to eq [new_category]
    end

    it "updates the last_cooked when incrementing times_cooked" do
      Timecop.freeze do
        recipe = create :recipe
        expect(recipe.last_cooked).to be_nil

        builder = described_class.new(recipe.id)
        builder.update(attributes: { times_cooked: "1" })
        recipe.reload

        expect(recipe.last_cooked).to be_within(0.01).of(Time.current)
      end
    end

    it "does not update the last_cooked when decrementing times_cooked" do
      Timecop.freeze do
        recipe = create :recipe, times_cooked: 1, last_cooked: 1.day.ago

        builder = described_class.new(recipe.id)
        builder.update(attributes: { times_cooked: "0" })
        recipe.reload

        expect(recipe.last_cooked).to be_within(0.01).of(1.day.ago)
      end
    end

    it "handle standard errors" do
      builder = RecipeBuilder.new
      allow(builder).to receive(:clean_attributes).and_raise("ERROR!")

      response = builder.update(attributes: {})

      expect(response.success).to eq false
      expect(response.errors).to eq ["Error modifying recipe", "ERROR!"]
    end
  end
end
