# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description "The query root of this schema"

    add_field(GraphQL::Types::Relay::NodeField)
    add_field(GraphQL::Types::Relay::NodesField)

    field :recipes, RecipeType.connection_type, null: false do
      argument :ingredient_search, String, required: false, default_value: ""
      argument :search_query, String, required: false, default_value: ""
      argument :tag_ids, [ID], required: false, default_value: []
      argument :up_next, Boolean, required: false, default_value: false
    end

    def recipes(
      search_query:, tag_ids:, up_next:, ingredient_search:
    )
      ::Queries::Recipes.call(
        user: context[:current_user],
        ingredient_search: ingredient_search,
        search_query: search_query,
        tag_ids: tag_ids,
        up_next: up_next
      )
    end

    field :recipe, RecipeType, null: false do
      argument :uuid, ID, required: true
    end
    def recipe(uuid:)
      Recipe.find(uuid)
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
