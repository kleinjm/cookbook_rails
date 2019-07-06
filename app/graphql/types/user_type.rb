# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements GraphQL::Relay::Node.interface
    global_id_field :id

    field :first_name, String, null: false
    field :last_name, String, null: false
    field :email, String, null: false
  end
end
