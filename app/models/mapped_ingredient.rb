# frozen_string_literal: true

class MappedIngredient < ApplicationRecord
  has_many :ingredients,
           inverse_of: :mapped_ingredient,
           dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
