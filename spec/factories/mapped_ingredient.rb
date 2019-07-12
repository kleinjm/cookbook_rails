# frozen_string_literal: true

FactoryBot.define do
  factory :mapped_ingredient do
    sequence(:name) { |n| "Salt#{n}" }
  end
end
