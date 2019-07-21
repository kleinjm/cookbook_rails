# frozen_string_literal: true

class Recipe < ApplicationRecord
  include GraphQL::Interface

  COOK_TIME_UNITS = %w[minutes hours days].freeze

  belongs_to :user, inverse_of: :recipes

  has_many :recipes_tags,
           class_name: "RecipeTag",
           dependent: :destroy
  has_many :tags,
           -> { order(:name) },
           through: :recipes_tags,
           inverse_of: :recipes

  has_many :images, dependent: :destroy

  has_many :ingredients_recipes,
           -> { order(:order) },
           class_name: "IngredientRecipe",
           dependent: :destroy,
           inverse_of: :recipe

  has_many :ingredients, through: :ingredients_recipes

  has_many :menus_recipes, dependent: :destroy, class_name: "MenuRecipe"
  has_many :menus, through: :menus_recipes

  validates :name, :times_cooked, :user_id, presence: true
  validates :cook_time_unit,
            inclusion: { in: COOK_TIME_UNITS },
            allow_nil: true
  validates :cook_time_quantity,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true
  validates :up_next, numericality: true
  validates :up_next, numericality: true
  validates :link, url: { allow_nil: true }

  def steps_count
    steps.lines.count
  end

  def step_list
    steps&.split("\n") || []
  end

  def ingredients_full_names(multiplier: 1)
    @ingredients_full_names ||=
      ingredients_recipes_including_relations.map do |join|
        # TODO: extract the trim functionality. The current code is dangerous
        # if the join or recipe gets saved and updates the quantity
        join.quantity = join.quantity * multiplier.to_f
        [join.quantity_trim, join.unit&.name, join.ingredient&.name].
          compact.join(" ")
      end
  end

  def self.up_next
    where("up_next > 0")
  end

  def self.reset_up_next
    up_next.find_each do |recipe|
      recipe.update(up_next: 0)
    end
  end

  def self.last_cooked_recipes(count:)
    where.
      not(last_cooked: nil).
      order("last_cooked DESC").
      limit(count)
  end

  # if this recipe is not persisted, do not try to load associations via the db
  def ingredients_recipes_including_relations
    if persisted?
      ingredients_recipes.includes(:unit, ingredient: [:mapped_ingredient])
    else
      ingredients_recipes
    end
  end
end
