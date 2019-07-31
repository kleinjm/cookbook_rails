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

    trait :with_cooked_at_dates do
      transient do
        cooked_at_count { 1 }
      end

      before(:create) do |recipe, evaluator|
        recipe.cooked_at_dates = Array.new(evaluator.cooked_at_count) do
          Time.current.to_date
        end
      end
    end

    trait :with_steps do
      "Cook\nThings"
    end
  end
end
