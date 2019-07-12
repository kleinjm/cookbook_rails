# frozen_string_literal: true

task split_categories_and_tags: :environment do
  CATEGORIES = ["Appetizers & Sides", "Entrees", "Desserts"].freeze

  Category.where.not(name: CATEGORIES).each do |category|
    tag = Tag.create!(name: category.name)

    category.recipes.each do |recipe|
      RecipeTag.create!(tag: tag, recipe: recipe)
    end

    category.destroy
  end
end
