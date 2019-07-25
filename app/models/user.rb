# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  include GraphQL::Interface

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :recipes, dependent: :destroy, inverse_of: :user
  has_many :menus, dependent: :destroy, inverse_of: :user
  has_many :tags, dependent: :destroy, inverse_of: :user

  validates :first_name, :last_name, :email, presence: true
end
