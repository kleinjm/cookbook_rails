# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::AddRecipesToMenu do
  it "adds recipes to a menu" do
    recipe_one = create(:recipe)
    recipe_two = create(:recipe)
    menu = create(:menu)

    variables = {
      "recipeIds" => [recipe_one.gql_id, recipe_two.gql_id],
      "menuId" => menu.gql_id
    }
    response = gql_query(query: mutation, variables: variables).
               to_h.deep_symbolize_keys.dig(:data, :addRecipesToMenu)

    expect(response[:success]).to eq(true)
    expect(response[:errors]).to be_empty
    expect(response.dig(:menu, :id)).to eq(menu.gql_id)
    expect(response.dig(:menu, :recipes).map { |r| r[:id] }).
      to contain_exactly(recipe_one.gql_id, recipe_two.gql_id)
  end

  it "does not add a recipe to a menu if already related" do
    recipe = create(:recipe)
    menu = create(:menu)
    menu.recipes << recipe

    variables = { "recipeIds" => [recipe.gql_id], "menuId" => menu.gql_id }
    expect { gql_query(query: mutation, variables: variables) }.
      to change(MenuRecipe, :count).by(0)

    expect(menu.reload.recipes).to eq([recipe])
  end

  def mutation
    <<~GQL
      mutation addRecipesToMenu($recipeIds: [ID!]!, $menuId: ID!) {
        addRecipesToMenu(input:{ recipeIds: $recipeIds, menuId: $menuId }) {
          menu {
            id
            name
            recipes {
              id
              name
            }
          }
          errors
          success
        }
      }
    GQL
  end
end
