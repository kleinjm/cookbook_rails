# frozen_string_literal: true

FactoryBot.define do
  factory :tag, class: "Tag" do
    association(:user)
    sequence(:name) { |n| "Tag-#{n}" }

    trait :in_group do
      association(:tag_group)
    end
  end
end
