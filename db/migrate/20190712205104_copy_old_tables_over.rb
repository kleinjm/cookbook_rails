# frozen_string_literal: true

class CopyOldTablesOver < ActiveRecord::Migration[5.2]
  def change
    create_table "images", id: :uuid, force: :cascade do |t|
      t.string "cl_id"
      t.binary "data", null: false
      t.string "filename"
      t.string "mime_type"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "recipe_id", null: false
      t.references :recipe, foreign_key: true, index: false, type: :uuid
      t.index ["recipe_id"], name: "index_images_on_recipe_id", unique: true
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
      t.integer "mapped_ingredient_id"
      t.references :mapped_ingredient, foreign_key: true, index: false, type: :uuid
      t.index ["mapped_ingredient_id"], name: "index_ingredients_on_mapped_ingredient_id"
      t.index ["name"], name: "index_ingredients_on_name", unique: true
    end

    create_table "units", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["name"], name: "index_units_on_name", unique: true
    end

    create_table "ingredients_recipes", id: :uuid, force: :cascade do |t|
      t.integer "ingredient_id", null: false
      t.integer "recipe_id", null: false
      t.integer "unit_id"
      t.float "quantity"
      t.integer "order"
      t.references :ingredient, foreign_key: true, index: false, type: :uuid
      t.references :recipe, foreign_key: true, index: false, type: :uuid
      t.references :unit, foreign_key: true, index: false, type: :uuid
      t.index ["ingredient_id"], name: "index_ingredients_recipes_on_ingredient_id"
      t.index ["recipe_id"], name: "index_ingredients_recipes_on_recipe_id"
      t.index ["unit_id"], name: "index_ingredients_units_on_unit_id"
    end

    create_table "menus", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.text "description"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.references :user, foreign_key: true, index: false, type: :uuid, null: false
      t.index %w[user_id name], name: "index_menus_on_user_id_and_name", unique: true
    end

    create_table "menus_recipes", id: :uuid, force: :cascade do |t|
      t.integer "menu_id", null: false
      t.integer "recipe_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.references :menu, foreign_key: true, index: false, type: :uuid
      t.references :recipe, foreign_key: true, index: false, type: :uuid
      t.index %w[menu_id recipe_id], name: "index_menus_recipes_on_menu_id_and_recipe_id", unique: true
    end

    create_table "tags", id: :uuid, force: :cascade do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.references :user, foreign_key: true, index: false, type: :uuid, null: false
      t.index %w[user_id name], name: "index_tags_on_user_id_and_name", unique: true
    end

    create_table "recipes_tags", id: :uuid, force: :cascade do |t|
      t.integer "recipe_id", null: false
      t.integer "tag_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.references :recipe, foreign_key: true, index: false, type: :uuid
      t.references :tag, foreign_key: true, index: false, type: :uuid
      t.index ["recipe_id"], name: "index_recipes_tags_on_recipe_id"
      t.index ["tag_id"], name: "index_recipes_tags_on_tag_id"
    end

    add_column :recipes, :cook_time_unit, :string # TODO: drop this column
    # TODO: treat this as number of seconds
    add_column :recipes, :cook_time_quantity, :integer
  end
end
