# frozen_string_literal: true

module Queries
  class Recipes
    def self.call(
      search_query: "", tag_ids: [], up_next: false, ingredient_search: "",
      user: nil
    )
      new(
        user: user,
        ingredient_search: ingredient_search,
        search_query: search_query,
        tag_ids: tag_ids,
        up_next: up_next
      ).call
    end

    # rubocop:disable Metrics/MethodLength
    def call
      if user.blank?
        []
      elsif up_next
        up_next_recipes
      elsif search_recipes?
        recipe_search_results
      elsif ingredient_search.present?
        ingredient_search_results
      else
        all_recipes
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    attr_reader :search_query, :tag_ids, :up_next, :ingredient_search, :user

    def initialize(
      search_query:, tag_ids:, up_next:, ingredient_search:, user:
    )
      @user = user
      @ingredient_search = ingredient_search
      @search_query = search_query
      @tag_ids = tag_ids
      @up_next = up_next
    end

    def up_next_recipes
      base_query.up_next
    end

    def search_recipes?
      search_query.present? || tag_ids.present?
    end

    def recipe_search_results
      searched_recipes = ::RecipeSearcher.new(
        search_query: search_query,
        tag_ids: tag_ids
      ).call
      base_query.merge(searched_recipes)
    end

    def ingredient_search_results
      searched_recipes =
        IngredientSearcher.new(query: ingredient_search).recipes_with_ingredient
      base_query.merge(searched_recipes)
    end

    def all_recipes
      base_query.includes(:recipes_tags, :tags).order(:name)
    end

    def base_query
      Recipe.where(user: user)
    end
  end
end
