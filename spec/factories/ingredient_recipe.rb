# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient_recipe do
    association :ingredient, strategy: :build
    association :recipe, strategy: :build

    trait :with_unit_and_quantity do
      association :unit, strategy: :build
      quantity { 10 }
    end
  end
end
