# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements GraphQL::Relay::Node.interface
    global_id_field :id

    field :first_name, String, null: false
    field :last_name, String, null: false

    field :email, String, null: true
    def email
      if object != context[:current_user]
        raise GraphQL::UnauthorizedFieldError,
              "Unable to access email of different account"
      end

      object.email
    end

    field :recipes, RecipeType.connection_type, null: false, max_page_size: 100
    def recipes
      if object != context[:current_user]
        raise GraphQL::UnauthorizedFieldError,
              "Unable to access recipes of different account"
      end

      object.recipes
    end
  end
end
