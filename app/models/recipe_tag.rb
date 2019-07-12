# frozen_string_literal: true

class RecipeTag < ApplicationRecord
  self.table_name = "recipes_tags"

  belongs_to :recipe
  belongs_to :tag

  validates :recipe, :tag, presence: true
end
