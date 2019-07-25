# frozen_string_literal: true

class RecipeSearcher
  def initialize(search_query: "", tag_ids: [])
    @search_query = search_query
    @tag_ids = tag_ids
  end

  def call
    @query = root_query
    name_search
    return filter_tags if tag_ids.present?

    query
  end

  private

  attr_reader :search_query, :tag_ids

  attr_accessor :query

  def root_query
    # TODO: adding `.includes(:recipes_tags, :tags)` breaks the search
    # if it's needed for n+1, come up with somewhere else to add it
    Recipe.order(:name).distinct
  end

  def name_search
    @query = query.where("recipes.name ILIKE :name", name: "%#{search_query}%")
  end

  def filter_tags
    query.
      joins(:recipes_tags).
      where(recipes_tags: { tag_id: tag_ids }).
      having("count(*) = #{tag_ids.count}").
      group("recipes.id")
  end
end
