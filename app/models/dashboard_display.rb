# frozen_string_literal: true

require "known_scrapers"

class DashboardDisplay
  # rubocop:disable Metrics/MethodLength
  def to_json(*_args)
    {
      ingredient_count: ingredient_count,
      ingredients_with_mapping_count: ingredients_with_mapping_count,
      last_n_recipes: last_n_recipes(5),
      orphaned_ingredients_count: orphaned_ingredients_count,
      recipe_count: recipe_count,
      site_recipe_counts: site_recipe_counts,
      tag_data: tag_data,
      total_times_cooked: total_times_cooked,
      unit_count: unit_count,
      users: users
    }.to_json
  end
  # rubocop:enable Metrics/MethodLength

  private

  def users
    @users ||= User.all
  end

  def recipe_count
    @recipe_count ||= Recipe.count
  end

  def ingredient_count
    @ingredient_count ||= Ingredient.count
  end

  # list of all websites and how many recipes belong to each
  def site_recipe_counts
    count = Hash.new(0)
    recipes = Recipe.where.not(link: nil).pluck(:link)
    recipes.map { |b| b.split("/")[2] }.each { |n| count[n] += 1 }
    count.sort_by { |_, value| value }.reverse
  end

  def orphaned_ingredients_count
    Ingredient.
      includes(ingredients_recipes: [:recipe]).
      where(ingredients_recipes: { recipe_id: nil }).
      count
  end

  def unit_count
    @unit_count ||= Unit.count
  end

  def tag_data
    Tag.includes(:recipes).all.each_with_object([]) do |tag, res|
      res << {
        name: tag.name,
        y: tag.recipes.count,
        drilldown: tag.name
      }
    end
  end

  def total_times_cooked
    Recipe.sum(:times_cooked)
  end

  def last_n_recipes(count = 10)
    recipes =
      Recipe.where.not(last_cooked: nil).order("last_cooked DESC").limit(count)

    ActiveModelSerializers::SerializableResource.new(
      recipes.to_a, each_serializer: RecipeIndexSerializer
    )
  end

  def ingredients_with_mapping_count
    Ingredient.where.not(mapped_ingredient_id: nil).count
  end
end
