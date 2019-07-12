# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::MutationResult do
  describe ".call" do
    it "returns the full hash with default keys" do
      user = User.new(first_name: "test")
      result = described_class.call(user)

      expect(result[:user].first_name).to eq("test")
      expect(result[:success]).to eq(true)
      expect(result[:errors]).to eq([])
    end

    it "returns the full hash with no object" do
      result = described_class.call

      expect(result.keys).to contain_exactly(:success, :errors)
      expect(result[:success]).to eq(true)
      expect(result[:errors]).to eq([])
    end

    it "returns the full hash with overrides" do
      user = User.new(first_name: "test")
      result = described_class.call(
        user, success: false, errors: ["blah"]
      )

      expect(result[:user].first_name).to eq("test")
      expect(result[:success]).to eq(false)
      expect(result[:errors]).to eq(["blah"])
    end

    it "returns the full hash with overrides and no object" do
      result = described_class.call(
        success: false, errors: ["blah"]
      )

      expect(result[:success]).to eq(false)
      expect(result[:errors]).to eq(["blah"])
    end
  end
end
