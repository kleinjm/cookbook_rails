# frozen_string_literal: true

require "bundler/setup"
require "wunderlist"

class WunderlistInterface
  FOOD_LIST = "Food" # the name of the grocery list

  def add_recipe(recipe:, multiplier: 1)
    full_names = recipe.ingredients_full_names(multiplier: multiplier)
    full_names.map { |ingredient| create_task(ingredient) }
    # TODO: count the responses instead of the given list
    full_names.count
  end

  private

  def create_task(name)
    task = client.new_task(FOOD_LIST, title: name, completed: false)
    task.save
  end

  def client
    return @client if defined?(@client)

    @client = Wunderlist::API.new(
      access_token: ENV.fetch("WL_ACCESS_TOKEN"),
      client_id: ENV.fetch("WL_CLIENT_ID")
    )
  end
end
