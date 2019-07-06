# frozen_string_literal: true

class Recipe < ApplicationRecord
  belongs_to :user, inverse_of: :recipes

  validates :name, :times_cooked, :user_id, presence: true
  validates :up_next, numericality: true
  validates :link, url: true
end
