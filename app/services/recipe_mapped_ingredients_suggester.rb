# frozen_string_literal: true

class RecipeMappedIngredientsSuggester
  MIN_INGREDIENT_LENGTH = 2

  def initialize(recipe_id:)
    @recipe_id = recipe_id
  end

  def call
    generate_ingredient_suggestions.to_json
  end

  private

  attr_reader :recipe_id

  def generate_ingredient_suggestions
    recipe_ingredients.each_with_object([]) do |ingredient, res|
      ingredient_json = {
        id: ingredient.id,
        name: ingredient.name,
        mapped_ingredient_id: ingredient.mapped_ingredient_id,
        recommended_mappings: recommended_mappings(ingredient: ingredient)
      }
      res << ingredient_json
    end
  end

  def recommended_mappings(ingredient:)
    words = ingredient.name.gsub(/\W|[0-9]/, " ").split(" ")
    words = words.
            select { |w| w.length > MIN_INGREDIENT_LENGTH }.
            map(&:downcase)

    recommendations = initial_recommendations(ingredient: ingredient)
    recommendations.concat(
      search_mapped_ingredients(ingredient: ingredient, words: words)
    )
  end

  def search_mapped_ingredients(ingredient:, words:)
    MappedIngredient.
      where("lower(name) similar to '%(#{words.join('|')})%'").
      where.not(id: ingredient.mapped_ingredient_id).
      each_with_object([]) do |mapping, res|
        res << { id: mapping.id, name: mapping.name, fresh: mapping.fresh }
      end
  end

  def initial_recommendations(ingredient:)
    return [] if ingredient.mapped_ingredient.blank?

    mapped_ingredient = ingredient.mapped_ingredient
    [{
      id: mapped_ingredient.id,
      name: mapped_ingredient.name,
      fresh: mapped_ingredient.fresh
    }]
  end

  def recipe_ingredients
    Recipe.find(recipe_id).
      ingredients.includes(:mapped_ingredient).
      without_titles
  end
end
