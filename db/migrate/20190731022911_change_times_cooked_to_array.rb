# frozen_string_literal: true

class ChangeTimesCookedToArray < ActiveRecord::Migration[5.2]
  def change
    remove_column :recipes, :times_cooked, :integer, default: 0, null: false
    remove_column :recipes, :last_cooked, :datetime

    add_column :recipes, :cooked_at_dates, :text, array: true, default: []
  end
end
