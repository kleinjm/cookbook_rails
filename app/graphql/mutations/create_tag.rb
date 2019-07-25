# frozen_string_literal: true

module Mutations
  class CreateTag < Mutations::BaseMutation
    argument :name, String, required: true

    field :tag, Types::TagType, null: true

    def resolve(**args)
      authorize_user

      args[:user] = context[:current_user]
      tag = Tag.new(args)
      success = tag.save

      MutationResult.call(
        tag,
        success: success,
        errors: tag.errors.full_messages
      )
    end
  end
end
