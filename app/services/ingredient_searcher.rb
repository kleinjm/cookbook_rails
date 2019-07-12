# frozen_string_literal: true

class IngredientSearcher
  def initialize(query:)
    @query = query
  end

  def recipes_with_ingredient
    Recipe.
      joins(ingredients_recipes: [:ingredient]).
      where("ingredients.name ILIKE :query", query: "%#{query}%").
      order(:name).
      distinct
  end

  private

  attr_reader :query
end
