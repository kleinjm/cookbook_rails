# frozen_string_literal: true

require "rails_helper"

RSpec.describe IngredientRecipe do
  describe "validations" do
    it { is_expected.to belong_to(:recipe) }
    it { is_expected.to belong_to(:ingredient) }
    it { is_expected.to belong_to(:unit) }
    it { is_expected.to validate_presence_of(:ingredient) }
    it { is_expected.to validate_presence_of(:recipe) }
  end

  describe "#quantity_trim" do
    it "returns 1 for 1.0" do
      expect(IngredientRecipe.new(quantity: 1.0).quantity_trim).to eq 1
    end

    it "returns nil for 0" do
      expect(IngredientRecipe.new(quantity: 0).quantity_trim).to be_nil
    end

    it "returns nil for 0.0" do
      expect(IngredientRecipe.new(quantity: 0.0).quantity_trim).to be_nil
    end

    it "returns 0.25" do
      expect(IngredientRecipe.new(quantity: 0.25).quantity_trim).to eq 0.25
    end
  end
end
