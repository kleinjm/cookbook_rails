# frozen_string_literal: true

FactoryBot.define do
  factory :tag_group, class: "TagGroup" do
    association(:user)
    sequence(:name) { |n| "TagGroup-#{n}" }

    trait :with_tags do
      transient do
        tag_count { 1 }
      end

      after(:create) do |group, evaluator|
        group.tags = create_list(:tag, evaluator.tag_count)
      end
    end
  end
end
