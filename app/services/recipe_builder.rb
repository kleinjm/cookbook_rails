# frozen_string_literal: true

class RecipeBuilder
  attr_accessor :recipe

  def initialize(id = nil)
    @recipe = id.present? ? Recipe.find(id) : Recipe.new
  end

  def create(attributes: {})
    clean_attributes(attributes)
    titleize(attributes)
    parse_ingredients(attributes)
    sync_tags(attributes)
    recipe.assign_attributes(attributes)
    recipe.save
    recipe_response
  rescue StandardError => e
    error_response(e)
  end

  # updates only the given attributes
  def update(attributes: {})
    clean_attributes(attributes)
    titleize(attributes)
    sync_tags(attributes)
    parse_ingredients(attributes)
    touch_times_cooked(attributes)
    recipe.update(attributes)
    recipe_response
  rescue StandardError => e
    error_response(e)
  end

  private

  TAG_IDS_ATTR = :tag_ids
  private_constant :TAG_IDS_ATTR

  # sync the tags if attributes has tags (even if it's set to [])
  def sync_tags(attributes)
    return unless attributes.key?(TAG_IDS_ATTR)

    recipe.tags = Tag.find_by(gql_ids: attributes[TAG_IDS_ATTR])
    attributes.delete(TAG_IDS_ATTR)
  end

  def parse_ingredients(attributes)
    return unless attributes.key? :ingredients

    ingredients = attributes[:ingredients]
    IngredientParser.new(ingredients&.split("\n")).assign_to_recipe(recipe)
    attributes.delete(:ingredients) if attributes.key? :ingredients
  end

  def clean_attributes(attributes)
    return attributes if attributes["steps"].blank?

    attributes["steps"] = attributes["steps"].each_line.map do |x|
      # remove extra new lines
      next if x.strip == ""

      # remove leading white space
      x.lstrip
    end.join
  end

  def titleize(attributes)
    return unless attributes.key? :name

    attributes[:name] = attributes[:name].titleize
  end

  def touch_times_cooked(attributes)
    return if attributes[:times_cooked].blank?
    return if attributes[:times_cooked].to_i <= recipe.times_cooked

    recipe.last_cooked = Time.current
  end

  def recipe_response
    {
      recipe: recipe,
      success: recipe.errors.blank?,
      errors: recipe.errors
    }
  end

  def error_response(error)
    {
      recipe: recipe,
      success: false,
      errors: ["Error modifying recipe", error.to_s]
    }
  end
end
