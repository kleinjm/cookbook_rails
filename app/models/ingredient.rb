# frozen_string_literal: true

# Ingredients beginning with # are titles for sections of the recipe
class Ingredient < ApplicationRecord
  has_many :ingredients_recipes,
           class_name: "IngredientRecipe",
           dependent: :destroy,
           inverse_of: :ingredient
  has_many :recipes, through: :ingredients_recipes

  belongs_to :mapped_ingredient,
             inverse_of: :ingredients,
             optional: true

  validates :name, presence: true

  def self.without_titles
    where.not("name LIKE '#%'")
  end
end
