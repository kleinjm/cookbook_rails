# frozen_string_literal: true

class TagGroup < ApplicationRecord
  include GraphQL::Interface

  belongs_to :user, inverse_of: :tag_groups
  has_many :tags, dependent: :destroy, inverse_of: :tag_group

  validates :name, presence: true
end
