# frozen_string_literal: true

module Queries
  class Recipes
    # rubocop:disable Metrics/ParameterLists
    def self.call(
      search_query: "", tag_ids: [], up_next: false,
      last_cooked: 0, ingredient_search: "", user: nil
    )
      new(
        user: user,
        ingredient_search: ingredient_search,
        last_cooked: last_cooked,
        search_query: search_query,
        tag_ids: tag_ids,
        up_next: up_next
      ).call
    end
    # rubocop:enable Metrics/ParameterLists

    # rubocop:disable Metrics/MethodLength
    def call
      if user.blank?
        []
      elsif up_next
        up_next_recipes
      elsif last_cooked.positive?
        last_cooked_recipes
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

    attr_reader :search_query, :tag_ids, :up_next,
                :last_cooked, :ingredient_search, :user

    # rubocop:disable Metrics/ParameterLists
    def initialize(
      search_query:, tag_ids:, up_next:, last_cooked:,
      ingredient_search:, user:
    )
      @user = user
      @ingredient_search = ingredient_search
      @last_cooked = last_cooked
      @search_query = search_query
      @tag_ids = tag_ids
      @up_next = up_next
    end
    # rubocop:enable Metrics/ParameterLists

    def up_next_recipes
      base_query.up_next
    end

    def last_cooked_recipes
      base_query.last_cooked_recipes(count: last_cooked)
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
