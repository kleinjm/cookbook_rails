# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "validations and relations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  describe "callbacks" do
    it "creates an auth token before saving if one does not exist" do
      # See: Devise initializer `config.http_authenticatable = true`
      user = build(:user)
      expect(user.authentication_token).to be_blank

      user.save!

      expect(user.reload.authentication_token).to_not be_blank
    end
  end

  describe "#name" do
    it "returns the full name" do
      user = User.new(first_name: "first", last_name: "last")

      expect(user.name).to eq("first last")
    end
  end
end
