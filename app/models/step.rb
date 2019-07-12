# frozen_string_literal: true

class Step < ApplicationRecord
  belongs_to :recipe

  validates :body, :order, :recipe, presence: true
end
