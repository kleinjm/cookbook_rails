# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::BaseMutation do
  describe "#authorize_user" do
    it "returns true if user is signed in" do
      mutation = Mutations::BaseMutation.new(
        object: nil, context: { current_user: double }
      )

      expect(mutation.send(:authorize_user)).to eq(true)
    end

    it "raise an error if not signed in" do
      mutation = Mutations::BaseMutation.new(
        object: nil, context: { current_user: nil }
      )

      expect { mutation.send(:authorize_user) }.
        to raise_error(GraphQL::ExecutionError, "User not signed in")
    end
  end

  describe "#authorize_for_object" do
    it "raise an error if not signed in" do
      mutation = Mutations::BaseMutation.new(
        object: nil, context: { current_user: nil }
      )

      expect { mutation.send(:authorize_for_object) }.
        to raise_error(GraphQL::ExecutionError, "User not signed in")
    end

    it "returns true if user owns the model" do
      user = double :user
      object = double :object, user: user
      mutation = Mutations::BaseMutation.new(
        object: object, context: { current_user: user }
      )

      expect(mutation.send(:authorize_for_object, object)).to eq(true)
    end

    it "raise an error if not the user owner" do
      object = double :object, user: double(:other_user)
      mutation = Mutations::BaseMutation.new(
        object: object, context: { current_user: double(:my_user) }
      )

      expect { mutation.send(:authorize_for_object) }.
        to raise_error(
          GraphQL::ExecutionError, "Unauthorized to change this object"
        )
    end
  end

  describe "#authorize_for_objects" do
    it "raise an error if not signed in" do
      mutation = Mutations::BaseMutation.new(
        object: nil, context: { current_user: nil }
      )

      expect { mutation.send(:authorize_for_objects, []) }.
        to raise_error(GraphQL::ExecutionError, "User not signed in")
    end

    it "returns true if user owns all models" do
      user = double :user, id: 1
      object = double :object

      objects = double :objects
      allow(objects).to receive(:pluck).and_return([user.id])

      mutation = Mutations::BaseMutation.new(
        object: object, context: { current_user: user }
      )

      expect(mutation.send(:authorize_for_objects, objects)).to eq(true)
    end

    it "raise an error if not the owner of all objects" do
      user = double :user, id: 1
      non_owner = double :user, id: 2
      object = double :object

      objects = double :objects
      allow(objects).to receive(:pluck).and_return([user.id, non_owner.id])

      mutation = Mutations::BaseMutation.new(
        object: object, context: { current_user: user }
      )

      expect { mutation.send(:authorize_for_objects, objects) }.
        to raise_error(
          GraphQL::ExecutionError,
          I18n.t("mutations.base_mutation.unauthorized_for_objects")
        )
    end
  end
end
