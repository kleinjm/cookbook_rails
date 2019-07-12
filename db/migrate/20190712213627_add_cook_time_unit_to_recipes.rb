# frozen_string_literal: true

class AddCookTimeUnitToRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :cook_time_unit, :string # TODO: drop this column
    # TODO: treat this as number of seconds
    add_column :recipes, :cook_time_quantity, :integer
  end
end
