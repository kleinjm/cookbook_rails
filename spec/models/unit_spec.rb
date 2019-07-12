# frozen_string_literal: true

require "rails_helper"

RSpec.describe Unit do
  describe "validations" do
    subject { create :unit }
    it do
      is_expected.
        to have_many(:ingredients_recipes).
        class_name("IngredientRecipe").
        dependent(:nullify)
    end
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
