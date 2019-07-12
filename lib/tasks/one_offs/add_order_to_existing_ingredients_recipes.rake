# frozen_string_literal: true

namespace :ingredients_recipes do
  task add_order: :environment do
    Recipe.find_each do |recipe|
      n = 0
      recipe.ingredients_recipes.each do |join|
        join.update(order: n)
        n += 1
      end
    end
  end
end
