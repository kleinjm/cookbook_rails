# frozen_string_literal: true

require "rails_helper"

RSpec.describe CookbookRailsSchema do
  describe ".resolve_type" do
    it "resolves the given type dynamically" do
      [Menu, Recipe, User].each do |klass|
        expect(described_class.resolve_type(nil, klass.new, nil).name).
          to eq(klass.name)
      end
    end

    it "raises an error for unknown type" do
      expect { described_class.resolve_type(nil, RSpec, nil) }.
        to raise_error(RuntimeError, "Unexpected object: RSpec")
    end
  end

  describe ".id_from_object" do
    it "returns the gql id for the given object" do
      uuid = SecureRandom.uuid
      user = User.new(id: uuid)
      expect(described_class.id_from_object(user, nil, nil)).
        to eq("User/#{uuid}")
    end
  end

  describe ".object_from_id" do
    it "returns an instance of the object from the given gql id" do
      user = create(:user)
      expect(described_class.object_from_id(user.gql_id, nil)).to eq(user)
    end
  end

  describe ".unauthorized_object" do
    it "raises a permissions error" do
      error = double :error, message: "Error!"

      expect { described_class.unauthorized_object(error) }.to raise_error(
        GraphQL::ExecutionError, "Error!"
      )
    end
  end
end
