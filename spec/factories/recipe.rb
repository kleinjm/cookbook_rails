# frozen_string_literal: true

FactoryBot.define do
  factory :recipe do
    association(:user)
    sequence(:name) { |n| "Recipe-#{n}" }

    trait :with_ingredient do
      after(:create) do |recipe|
        create :ingredient_recipe, :with_unit_and_quantity, recipe: recipe
      end
    end
  end
end
