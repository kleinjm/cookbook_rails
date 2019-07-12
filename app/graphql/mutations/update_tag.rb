# frozen_string_literal: true

module Mutations
  class UpdateTag < Mutations::BaseMutation
    argument :tag_id, ID, required: true, loads: Types::TagType

    argument :name, String, required: true

    field :tag, Types::TagType, null: true

    def resolve(tag:, **args)
      authorize_for_object(tag)

      success = tag.update(args)

      MutationResult.call(
        obj: { tag: tag },
        success: success,
        errors: tag.errors.full_messages
      )
    end
  end
end
