# frozen_string_literal: true

module Queries
  class Recipes
    # rubocop:disable Metrics/ParameterLists
    def self.call(
      search_query: "", tag_ids: [], category_ids: [], this_week: false,
      last_cooked: 0, ingredient_search: "", user: nil
    )
      new(
        category_ids: category_ids,
        user: user,
        ingredient_search: ingredient_search,
        last_cooked: last_cooked,
        search_query: search_query,
        tag_ids: tag_ids,
        this_week: this_week
      ).call
    end
    # rubocop:enable Metrics/ParameterLists

    # rubocop:disable Metrics/MethodLength
    def call
      if user.blank?
        []
      elsif this_week
        this_week_recipes
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

    attr_reader :search_query, :tag_ids, :category_ids, :this_week,
                :last_cooked, :ingredient_search, :user

    # rubocop:disable Metrics/ParameterLists
    def initialize(
      search_query:, tag_ids:, category_ids:, this_week:, last_cooked:,
      ingredient_search:, user:
    )
      @category_ids = category_ids
      @user = user
      @ingredient_search = ingredient_search
      @last_cooked = last_cooked
      @search_query = search_query
      @tag_ids = tag_ids
      @this_week = this_week
    end
    # rubocop:enable Metrics/ParameterLists

    def this_week_recipes
      base_query.this_week
    end

    def last_cooked_recipes
      base_query.last_cooked_recipes(count: last_cooked)
    end

    def search_recipes?
      search_query.present? || tag_ids.present? || category_ids.present?
    end

    def recipe_search_results
      searched_recipes = ::RecipeSearcher.new(
        search_query: search_query,
        tag_gql_ids: tag_ids,
        category_gql_ids: category_ids
      ).call
      base_query.merge(searched_recipes)
    end

    def ingredient_search_results
      searched_recipes =
        IngredientSearcher.new(query: ingredient_search).recipes_with_ingredient
      base_query.merge(searched_recipes)
    end

    def all_recipes
      base_query.all.order(:name)
    end

    def base_query
      Recipe.where(user: user)
    end
  end
end
