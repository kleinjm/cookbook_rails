# frozen_string_literal: true

FactoryBot.define do
  factory :tag, class: "Tag" do
    association(:user)
    sequence(:name) { |n| "Tag-#{n}" }
  end
end
