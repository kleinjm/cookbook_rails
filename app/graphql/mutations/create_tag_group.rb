# frozen_string_literal: true

require "graphql/types/tag_group_type"

module Mutations
  class CreateTagGroup < Mutations::BaseMutation
    argument :name, String, required: true

    field :tag_group, Types::TagGroupType, null: true

    def resolve(**args)
      authorize_user

      args[:user] = context[:current_user]
      tag_group = TagGroup.new(args)
      success = tag_group.save

      MutationResult.call(
        tag_group,
        success: success,
        errors: tag_group.errors.full_messages
      )
    end
  end
end
