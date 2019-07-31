# frozen_string_literal: true

require "rails_helper"

RSpec.describe CookedAtDateChanger do
  describe "#call" do
    it "increments the given recipe's cooked_at_dates" do
      recipe = create(:recipe)

      result = CookedAtDateChanger.new(recipe: recipe, amount: 2).call

      recipe.reload
      expect(result[:recipe]).to eq(recipe)
      expect(result[:success]).to eq(true)
      expect(result[:errors]).to be_empty
      expect(recipe.cooked_at_dates.count).to eq(2)
    end

    it "decrements the given recipe's cooked_at_dates" do
      recipe = create(:recipe, cooked_at_dates: [1.day.ago, 2.days.ago])

      result = CookedAtDateChanger.new(recipe: recipe, amount: -2).call

      recipe.reload
      expect(result[:recipe]).to eq(recipe)
      expect(result[:success]).to eq(true)
      expect(result[:errors]).to be_empty
      expect(recipe.cooked_at_dates.count).to be_zero
    end

    it "errors on 0 amount" do
      recipe = Recipe.new

      result = CookedAtDateChanger.new(recipe: recipe, amount: 0).call

      expect(result[:recipe]).to eq(recipe)
      expect(result[:success]).to eq(false)
      expect(result[:errors]).to_not be_empty
    end

    it "errors when decrementing more than exist" do
      recipe = Recipe.new

      result = CookedAtDateChanger.new(recipe: recipe, amount: -1).call

      expect(result[:recipe]).to eq(recipe)
      expect(result[:success]).to eq(false)
      expect(result[:errors]).to_not be_empty
    end
  end
end
