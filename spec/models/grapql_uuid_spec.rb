# frozen_string_literal: true

require "rails_helper"

RSpec.describe GraphqlUuid do
  describe ".encode" do
    it "encodes the give object" do
      id = SecureRandom.uuid
      user = User.new(id: id)

      expect(described_class.encode(user)).to eq("User/#{id}")
    end

    it "raises an error if no id is given" do
      user = User.new

      expect { described_class.encode(user) }.
        to raise_error(ArgumentError)
    end
  end

  describe ".decode" do
    it "decodes the give object" do
      id = SecureRandom.uuid
      user = User.new(id: id)

      expect(described_class.decode("User/#{id}")).to eq(["User", id])
    end

    it "raises an error if given id without slash" do
      expect { described_class.decode("bad-id") }.
        to raise_error(ArgumentError)
    end

    it "raises an error if given id with multiple slashes" do
      expect { described_class.decode("User/123/456") }.
        to raise_error(ArgumentError)
    end
  end
end
