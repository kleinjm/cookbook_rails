# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardDisplay do
  describe "#to_json" do
    it "returns the total times cooked for all recipes" do
      create_list :recipe, 2, times_cooked: 2
      result = JSON.parse(described_class.new.to_json)
      expect(result["total_times_cooked"]).to eq(4)
    end
  end
end
