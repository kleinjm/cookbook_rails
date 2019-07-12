# frozen_string_literal: true

FactoryBot.define do
  factory :menu do
    association(:user)
    sequence(:name) { |n| "Recipe ##{n}" }
  end
end
