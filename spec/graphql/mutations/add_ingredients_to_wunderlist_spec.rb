# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::AddIngredientsToWunderlist do
  it "adds the ingredients to wunderlist" do
    user = create(:user)
    recipe = create(:recipe, user: user)

    wl_interface = instance_double WunderlistInterface
    allow(WunderlistInterface).to receive(:new).and_return(wl_interface)
    allow(wl_interface).to receive(:add_recipe)

    variables = { "recipeId" => recipe.gql_id, "multiplier" => 3 }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :addIngredientsToWunderlist)

    expect(wl_interface).
      to have_received(:add_recipe).with(recipe: recipe, multiplier: 3)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank
    expect(result.dig(:recipe, :id)).to eq(recipe.gql_id)
  end

  def mutation
    <<~GQL
      mutation addIngredientsToWunderlist(
        $recipeId: ID!, $multiplier: Float
      ) {
        addIngredientsToWunderlist(
          input: { recipeId: $recipeId, multiplier: $multiplier }
        ) {
          recipe {
            id
            name
          }
          success
          errors
        }
      }
    GQL
  end
end
