# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "The query root of this schema"

    add_field(GraphQL::Types::Relay::NodeField)
    add_field(GraphQL::Types::Relay::NodesField)

    field :recipes, RecipeType.connection_type, null: false do
      argument :ingredientSearch, String, required: false, default_value: ""
      argument :lastCooked, Integer, required: false, default_value: 0
      argument :searchQuery, String, required: false, default_value: ""
      argument :tagIds, [ID], required: false, default_value: []
      argument :thisWeek, Boolean, required: false, default_value: false
    end

    # rubocop:disable Metrics/ParameterLists
    def recipes(
      search_query:, tag_ids:, up_next:, last_cooked:,
      ingredient_search:
    )
      ::Queries::Recipes.call(
        user: context[:current_user],
        ingredient_search: ingredient_search,
        last_cooked: last_cooked,
        search_query: search_query,
        tag_ids: tag_ids,
        up_next: up_next
      )
    end
    # rubocop:enable Metrics/ParameterLists

    field :tags, TagType.connection_type, null: false
    def tags
      Tag.where(user: context[:current_user]).order(:name)
    end

    field :menus, MenuType.connection_type, null: false
    def menus
      Menu.where(user: context[:current_user]).order(:created_at)
    end
  end
end
