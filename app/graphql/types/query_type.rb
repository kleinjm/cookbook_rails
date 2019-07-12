# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "The query root of this schema"

    field :node, field: GraphQL::Relay::Node.field
    field :nodes, field: GraphQL::Relay::Node.plural_field

    field :recipes, RecipeType.connection_type, null: false do
      argument :categoryIds, [ID], required: false, default_value: []
      argument :ingredientSearch, String, required: false, default_value: ""
      argument :lastCooked, Integer, required: false, default_value: 0
      argument :searchQuery, String, required: false, default_value: ""
      argument :tagIds, [ID], required: false, default_value: []
      argument :thisWeek, Boolean, required: false, default_value: false
    end

    # rubocop:disable Metrics/ParameterLists
    def recipes(
      search_query:, tag_ids:, category_ids:, this_week:, last_cooked:,
      ingredient_search:
    )
      ::Queries::Recipes.call(
        account: context[:current_account],
        category_ids: category_ids,
        ingredient_search: ingredient_search,
        last_cooked: last_cooked,
        search_query: search_query,
        tag_ids: tag_ids,
        this_week: this_week
      )
    end
    # rubocop:enable Metrics/ParameterLists

    field :tags, TagType.connection_type, null: false
    def tags
      Tag.where(account: context[:current_account]).order(:name)
    end

    field :menus, MenuType.connection_type, null: false
    def menus
      Menu.where(account: context[:current_account]).order(:created_at)
    end
  end
end
