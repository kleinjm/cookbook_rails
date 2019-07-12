# frozen_string_literal: true

class MenuRecipe < ApplicationRecord
  self.table_name = "menus_recipes"

  belongs_to :menu
  belongs_to :recipe

  validates :menu, :recipe, presence: true
end
