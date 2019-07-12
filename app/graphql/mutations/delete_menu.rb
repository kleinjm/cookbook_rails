# frozen_string_literal: true

module Mutations
  class DeleteMenu < Mutations::BaseMutation
    argument :menu_id, ID, required: true, loads: Types::MenuType

    field :menu, Types::MenuType, null: true

    def resolve(menu:)
      authorize_for_object(menu)

      menu.destroy
      MutationResult.call(
        obj: { menu: menu },
        errors: menu.errors.full_messages
      )
    end
  end
end
