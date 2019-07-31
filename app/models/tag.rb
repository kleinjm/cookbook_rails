# frozen_string_literal: true

class Tag < ApplicationRecord
  include GraphQL::Interface

  belongs_to :user, inverse_of: :tags
  belongs_to :tag_group, inverse_of: :tags, optional: true

  has_many :recipes_tags, class_name: "RecipeTag", dependent: :destroy
  has_many :recipes, through: :recipes_tags, inverse_of: :tags

  validates :name, presence: true
end
