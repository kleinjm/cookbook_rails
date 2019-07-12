# frozen_string_literal: true

module Mutations
  class CreateMenu < Mutations::BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false

    field :menu, Types::MenuType, null: true

    def resolve(**args)
      authorize_user

      args[:user] = context[:current_user]
      menu = Menu.new(args)
      success = menu.save

      MutationResult.call(
        obj: { menu: menu },
        success: success,
        errors: menu.errors.full_messages
      )
    end
  end
end
