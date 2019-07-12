# frozen_string_literal: true

class CopyOldTablesOver < ActiveRecord::Migration[5.2]
  def change
    create_table "images", id: :uuid, force: :cascade do |t|
      t.string "recipe_id", null: false
      t.string "cl_id"
      t.binary "data", null: false
      t.string "filename"
      t.string "mime_type"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "mapped_ingredients", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.boolean "fresh", default: false, null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_mapped_ingredients_on_name", unique: true
    end

    create_table "ingredients", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "mapped_ingredient_id"
      t.references :mapped_ingredients, foreign_key: true, index: false, type: :uuid
      t.index ["mapped_ingredient_id"], name: "index_ingredients_on_mapped_ingredient_id"
      t.index ["name"], name: "index_ingredients_on_name", unique: true
    end

    create_table "ingredients_recipes", id: :uuid, force: :cascade do |t|
      t.string "ingredient_id", null: false
      t.string "recipe_id", null: false
      t.string "unit_id"
      t.float "quantity"
      t.integer "order"
      t.references :ingredients, foreign_key: true, index: false, type: :uuid
      t.references :recipes, foreign_key: true, index: false, type: :uuid
      t.index ["ingredient_id"], name: "index_ingredients_recipes_on_ingredient_id"
      t.index ["recipe_id"], name: "index_ingredients_recipes_on_recipe_id"
    end

    create_table "menus", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "user_id", null: false
      t.references :users, foreign_key: true, index: false, type: :uuid
      t.index %w[user_id name], name: "index_menus_on_user_id_and_name", unique: true
    end

    create_table "menus_recipes", id: :uuid, force: :cascade do |t|
      t.string "menu_id", null: false
      t.string "recipe_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.references :menus, foreign_key: true, index: false, type: :uuid
      t.references :recipes, foreign_key: true, index: false, type: :uuid
      t.index %w[menu_id recipe_id], name: "index_menus_recipes_on_menu_id_and_recipe_id", unique: true
    end

    create_table "tags", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "user_id", null: false
      t.references :users, foreign_key: true, index: false, type: :uuid
      t.index %w[user_id name], name: "index_tags_on_user_id_and_name", unique: true
    end

    create_table "recipes_tags", id: :uuid, force: :cascade do |t|
      t.bigint "recipe_id", null: false
      t.bigint "tag_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.references :recipes, foreign_key: true, index: false, type: :uuid
      t.references :tags, foreign_key: true, index: false, type: :uuid
      t.index ["recipe_id"], name: "index_recipes_tags_on_recipe_id"
      t.index ["tag_id"], name: "index_recipes_tags_on_tag_id"
    end

    create_table "units", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_units_on_name", unique: true
    end
  end
end
