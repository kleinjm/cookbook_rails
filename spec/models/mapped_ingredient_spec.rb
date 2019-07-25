# frozen_string_literal: true

require "rails_helper"

RSpec.describe MappedIngredient do
  describe "relationships and validations" do
    it do
      is_expected.to have_many(:ingredients).
        inverse_of(:mapped_ingredient).dependent(:nullify)
    end

    it { is_expected.to validate_presence_of(:name) }
  end
end
