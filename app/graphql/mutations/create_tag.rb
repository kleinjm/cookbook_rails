# frozen_string_literal: true

module Mutations
  class CreateTag < Mutations::BaseMutation
    argument :name, String, required: true

    field :tag, Types::TagType, null: true

    def resolve(**args)
      authorize_account

      args[:account] = context[:current_account]
      tag = Tag.new(args)
      success = tag.save

      MutationResult.call(
        obj: { tag: tag },
        success: success,
        errors: tag.errors.full_messages
      )
    end
  end
end
