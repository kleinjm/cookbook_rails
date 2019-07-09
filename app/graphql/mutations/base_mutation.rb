# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    # This is used for generating the `input: { ... }` object type
    input_object_class Types::BaseInputObject

    # No support for return_interfaces
    # See https://github.com/rmosolgo/graphql-ruby/issues/1837
    field :success, Boolean, null: false
    field :errors, [String], null: true

    protected

    def authorize_user
      return true if context[:current_user].present?

      raise GraphQL::ExecutionError, "User not signed in"
    end

    def authorize_for_object(model = object)
      authorize_user
      return true if model&.user == context[:current_user]

      raise GraphQL::ExecutionError, "Unauthorized to change this object"
    end

    def authorize_for_objects(models)
      authorize_user
      return true if models.pluck(:user_id).all? do |user_id|
        user_id == context[:current_user].id
      end

      raise GraphQL::ExecutionError, "Unauthorized to change all these objects"
    end
  end
end
