# frozen_string_literal: true

class CreateTagGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_groups, id: :uuid do |t|
      t.references :user,
                   foreign_key: true, index: false, type: :uuid, null: false
      t.index [:user_id, :name], unique: true

      t.string :name, null: false

      t.timestamps
    end

    change_table :tags do |t|
      t.references :tag_group, foreign_key: true, index: true, type: :uuid
    end
  end
end
