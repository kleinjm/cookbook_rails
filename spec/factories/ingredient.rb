# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "Salt#{n}" }

    trait :title do
      name { "# Sauce" }
    end
  end
end
