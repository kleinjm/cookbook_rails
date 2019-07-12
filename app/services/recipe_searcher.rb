# frozen_string_literal: true

class RecipeSearcher
  def initialize(search_query: "", tag_gql_ids: [], category_gql_ids: [])
    @search_query = search_query
    @tag_gql_ids = tag_gql_ids
    @category_gql_ids = category_gql_ids
  end

  def call
    @query = root_query
    name_search
    return filter_tags_and_categories if tags_and_categories?
    return filter_tags if tag_gql_ids.present?
    return filter_categories if category_gql_ids.present?

    query
  end

  private

  attr_reader :search_query, :tag_gql_ids, :category_gql_ids

  attr_accessor :query

  def root_query
    # TODO: adding `.includes(:recipes_tags, :tags)` breaks the search
    # if it's needed for n+1, come up with somewhere else to add it
    Recipe.order(:name).distinct
  end

  def name_search
    @query = query.where("recipes.name ILIKE :name", name: "%#{search_query}%")
  end

  def tags_and_categories?
    tag_gql_ids.present? && category_gql_ids.present?
  end

  def filter_tags_and_categories
    max_count = [tag_gql_ids.size, category_gql_ids.size].max
    query.
      joins(:recipes_tags).
      joins(:categories_recipes).
      where(recipes_tags: { tag_id: tag_ids }).
      where(categories_recipes: { category_id: category_ids }).
      group("recipes.id").
      having("count(*) = #{max_count}")
  end

  def filter_tags
    query.
      joins(:recipes_tags).
      where(recipes_tags: { tag_id: tag_ids }).
      having("count(*) = #{tag_ids.count}").
      group("recipes.id")
  end

  def filter_categories
    query.
      joins(:categories_recipes).
      where(categories_recipes: { category_id: category_ids }).
      having("count(*) = #{category_ids.count}").
      group("recipes.id")
  end

  def tag_ids
    Tag.find_by(gql_ids: tag_gql_ids).pluck(:id)
  end

  def category_ids
    Category.find_by(gql_ids: category_gql_ids).pluck(:id)
  end
end
