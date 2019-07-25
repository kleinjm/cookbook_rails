# frozen_string_literal: true

class StepMigrator
  def migrate
    ActiveRecord::Base.transaction do
      Recipe.where(bookmark: false).find_each do |recipe|
        recipe.steps = recipe.steps.join("\n")
        recipe.save!

        recipe.ingredients.each do |ingredient|
          split_ingredient = ingredient.gsub(/[[:space:]]+/, " ").split(" ")

          # quantity
          join = IngredientRecipe.new
          quantity = to_frac(split_ingredient.first)
          join.quantity = quantity if quantity > 0

          # unit
          if quantity > 0 && units.include?(split_ingredient.second)
            unit = Unit.find_or_create_by(name: split_ingredient.second.downcase.strip)
            join.unit = unit
          end

          # name
          name =
            if quantity > 0
              split_at = split_ingredient.length > 2 ? 2 : 1
              split_ingredient[split_at..-1].join(" ").capitalize
            else
              ingredient
            end
          ar_ingredient = Ingredient.find_or_create_by(name: name)

          join.recipe = recipe
          join.ingredient = ar_ingredient
          join.save
        end
      end
    end
  end

  private

  def to_frac(num)
    numerator, denominator = num.split("/").map(&:to_f)
    denominator ||= 1
    numerator / denominator
  end

  def units
    ["large",
     "c",
     "g",
     "bunch",
     "drizzle",
     "tablespoons",
     "cup",
     "tablespoon",
     "teaspoon",
     "t",
     "oz",
     "stick",
     "lb",
     "T",
     "clv",
     "med",
     "lg",
     "head",
     "slat",
     "Large,",
     "Large",
     "cloves",
     "can",
     "3-finger",
     "pinch",
     "slices",
     "small",
     "teaspoons",
     "cups",
     "lbs",
     "Whole",
     "medium",
     "handful",
     "shakes",
     "3f-pinches",
     "whole",
     "md",
     "Small",
     "bag",
     "bottle",
     "pound",
     "splash",
     "clove",
     "sm",
     "lb.",
     "t",
     "dash",
     "heads",
     "dollop",
     "pounds",
     "ounces",
     "chuncks",
     "quart"]
  end
end

namespace :recipes do
  task migrate_step_and_ingredients: :environment do
    StepMigrator.new.migrate
  end
end
