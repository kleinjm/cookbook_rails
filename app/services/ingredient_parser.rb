# frozen_string_literal: true

class IngredientParser
  def initialize(raw_text)
    @raw_text = raw_text
  end

  def assign_to_recipe(recipe)
    @recipe = recipe
    if raw_text.blank?
      recipe.ingredients_recipes = []
      return
    end

    raw_text.reject!(&:empty?) # handle blank lines
    recipe.ingredients_recipes = joins_from_raw_text(raw_text)
  end

  private

  attr_reader :raw_text, :recipe

  def joins_from_raw_text(raw_text)
    raw_text.each_with_index.map do |ingredient_text, index|
      create_join(
        ingredient_text: ingredient_text, index: index
      )
    end
  end

  def create_join(ingredient_text:, index:)
    ingredient_parsed = IngreedyWrapper.parse(ingredient_text)
    ingredient = find_or_create_ingredient(ingredient_parsed.ingredient)
    unit = find_or_create_unit(ingredient_parsed.unit)
    IngredientRecipe.where(ingredient: ingredient, recipe: recipe).
      find_or_initialize_by(
        unit: unit, quantity: ingredient_parsed.amount.to_f, order: index
      )
  end

  def find_or_create_ingredient(ingredient_name)
    name = ingredient_name.capitalize
    Ingredient.find_or_create_by(name: name)
  end

  def find_or_create_unit(unit)
    return if unit.blank?

    Unit.find_or_create_by(name: unit.to_s)
  end
end
