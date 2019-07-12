# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ingredient do
  describe "validations" do
    subject { create :ingredient }

    it do
      is_expected.
        to have_many(:ingredients_recipes).
        class_name("IngredientRecipe").
        dependent(:destroy).
        inverse_of(:ingredient)
    end
    it { is_expected.to have_many(:recipes).through(:ingredients_recipes) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
