# frozen_string_literal: true

module Types
  class RecipeType < Types::BaseObject
    implements GraphQL::Relay::Node.interface
    global_id_field :id

    field :name, String, null: false
    field :times_cooked, Integer, null: false
    field :link, String, null: true
    field :description, String, null: true
    field :steps, String, null: true
    field :source, String, null: true
    field :up_next, Float, null: false
    field :last_cooked, GraphQL::Types::ISO8601DateTime, null: true
    field :user, Types::UserType, null: true
  end
end
