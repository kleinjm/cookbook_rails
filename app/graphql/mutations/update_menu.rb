# frozen_string_literal: true

module Mutations
  class UpdateMenu < Mutations::BaseMutation
    argument :menu_id, ID, required: true, loads: Types::MenuType

    argument :name, String, required: false
    argument :description, String, required: false

    field :menu, Types::MenuType, null: true

    def resolve(menu:, **args)
      authorize_for_object(menu)

      success = menu.update(args)

      MutationResult.call(
        menu,
        success: success,
        errors: menu.errors.full_messages
      )
    end
  end
end
