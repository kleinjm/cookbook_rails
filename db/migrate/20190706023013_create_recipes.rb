# frozen_string_literal: true

class CreateRecipes < ActiveRecord::Migration[5.2]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.integer :times_cooked, default: 0, null: false
      t.string :link
      t.string :description
      t.text :steps
      t.string :source
      t.float :up_next, default: 0.0, null: false
      t.datetime :last_cooked
      t.integer :user_id, null: false
      t.references :user, foreign_key: true, index: false
      t.index [:user_id, :link], unique: true

      t.timestamps
    end
  end
end
