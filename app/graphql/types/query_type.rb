# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "The query root of this schema"

    add_field(GraphQL::Types::Relay::NodeField)
    add_field(GraphQL::Types::Relay::NodesField)

    field :recipes, RecipeType.connection_type, null: false do
      argument :ingredient_search, String, required: false, default_value: ""
      argument :last_cooked, Integer, required: false, default_value: 0
      argument :search_query, String, required: false, default_value: ""
      argument :tag_ids, [ID], required: false, default_value: []
      argument :up_next, Boolean, required: false, default_value: false
    end

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
