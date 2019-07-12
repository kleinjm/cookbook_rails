# frozen_string_literal: true

require "rails_helper"

RSpec.describe MenuRecipe do
  it { is_expected.to belong_to(:menu) }
  it { is_expected.to belong_to(:recipe) }
  it { is_expected.to validate_presence_of(:menu) }
  it { is_expected.to validate_presence_of(:recipe) }

  it "validates uniqueness of menu and recipe pairs" do
    menu = create(:menu)
    recipe = create(:recipe)

    expect { create(:menu_recipe, menu: menu, recipe: recipe) }.
      to change(MenuRecipe, :count).by(1)

    expect { create(:menu_recipe, menu: menu, recipe: recipe) }.
      to raise_error(ActiveRecord::RecordNotUnique)
  end
end
