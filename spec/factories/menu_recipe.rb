# frozen_string_literal: true

FactoryBot.define do
  factory :menu_recipe do
    association :menu, strategy: :build
    association :recipe, strategy: :build
  end
end
