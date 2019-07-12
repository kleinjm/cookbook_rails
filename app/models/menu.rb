# frozen_string_literal: true

class Menu < ApplicationRecord
  include GraphQL::Interface

  belongs_to :user

  has_many :menus_recipes, dependent: :destroy, class_name: "MenuRecipe"
  has_many :recipes, through: :menus_recipes

  validates :name, :user_id, presence: true
end
