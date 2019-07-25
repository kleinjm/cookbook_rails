# frozen_string_literal: true

module Mutations
  class DeleteTag < Mutations::BaseMutation
    argument :tag_id, ID, required: true, loads: Types::TagType

    field :tag, Types::TagType, null: true

    def resolve(tag:)
      authorize_for_object(tag)

      tag.destroy
      MutationResult.call(
        tag,
        errors: tag.errors.full_messages
      )
    end
  end
end
