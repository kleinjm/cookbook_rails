# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::MutationResult do
  describe ".call" do
    context "Enumerable" do
      it "returns the full hash with default keys" do
        user = User.new(first_name: "test")
        result = described_class.call(user)

        expect(result[:user].first_name).to eq("test")
        expect(result[:success]).to eq(true)
        expect(result[:errors]).to eq([])
      end

      it "returns the full hash for an array of objects" do
        first_user = User.new(first_name: "first")
        second_user = User.new(first_name: "second")
        result = described_class.call([first_user, second_user])

        expect(result[:users].first.first_name).to eq("first")
        expect(result[:users].second.first_name).to eq("second")
        expect(result[:success]).to eq(true)
        expect(result[:errors]).to eq([])
      end

      it "returns the full hash for an active record relation of objects" do
        create(:user, first_name: "first")
        create(:user, first_name: "second")
        result = described_class.call(User.all)

        expect(result[:users].first.first_name).to eq("first")
        expect(result[:users].second.first_name).to eq("second")
        expect(result[:success]).to eq(true)
        expect(result[:errors]).to eq([])
      end
    end

    context "single object" do
      it "returns the full hash with no object" do
        result = described_class.call

        expect(result.keys).to contain_exactly(:success, :errors)
        expect(result[:success]).to eq(true)
        expect(result[:errors]).to eq([])
      end

      it "returns multi word class names" do
        class MockClass; end
        mock_class = MockClass.new
        result = described_class.call(mock_class)

        expect(result[:mock_class]).to be_present
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
end
