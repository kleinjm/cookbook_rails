# frozen_string_literal: true

class Unit < ApplicationRecord
  has_many(
    :ingredients_recipes,
    class_name: "IngredientRecipe",
    dependent: :nullify
  )

  validates :name, presence: true, uniqueness: true
end
