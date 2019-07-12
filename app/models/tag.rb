# frozen_string_literal: true

class Tag < ApplicationRecord
  include GraphQL::Interface

  belongs_to :user

  has_many :recipes_tags, class_name: "RecipeTag", dependent: :destroy
  has_many :recipes, through: :recipes_tags, inverse_of: :tags

  validates :name, presence: true, uniqueness: true
end
