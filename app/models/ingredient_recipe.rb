# frozen_string_literal: true

class IngredientRecipe < ApplicationRecord
  self.table_name = :ingredients_recipes

  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :unit

  validates :ingredient, :recipe, presence: true
  # TODO: add unique validation and index for ingredient and recipe

  def self.by_order
    order(:order)
  end

  # return the quantity without .0 if there no need for it
  def quantity_trim
    float = quantity.to_f
    return nil if float.zero? # nil so you don't end up with "0 Salt to taste"

    int = quantity.to_i
    int == float ? int : float
  end
end
