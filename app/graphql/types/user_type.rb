# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements GraphQL::Relay::Node.interface
    global_id_field :id

    field :first_name, String, null: false
    field :last_name, String, null: false

    # TODO: properly handle errors
    field :email, String, null: true
    def email
      if object.id != context[:current_user]&.id
        raise GraphQL::UnauthorizedFieldError,
              "Unable to access authentication_token"
      end

      object.email
    end

    field :recipes, RecipeType.connection_type, null: false, max_page_size: 100
  end
end
