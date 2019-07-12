# frozen_string_literal: true

require "rails_helper"

RSpec.describe "layout components" do
  describe "navbar" do
    context "logged out" do
      it "is successful" do
        get root_path
        expect(response).to be_successful
      end
    end

    context "logged in" do
      it "is successful" do
        sign_in_user
        get root_path
        expect(response).to be_successful
      end
    end
  end
end
