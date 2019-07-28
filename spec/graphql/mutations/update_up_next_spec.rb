# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::UpdateUpNext do
  it "sets the up next value for all given recipes" do
    user = create(:user)
    first_recipe = create(:recipe, user: user)
    second_recipe = create(:recipe, user: user)
    up_next = 12.3

    variables = {
      "recipeIds" => [first_recipe.gql_id, second_recipe.gql_id],
      "upNext" => up_next
    }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :updateUpNext)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank

    expect(result[:recipes].map { |r| r[:upNext] }).to all(eq(up_next))

    first_recipe.reload
    expect(first_recipe.up_next).to eq(up_next)
    second_recipe.reload
    expect(second_recipe.up_next).to eq(up_next)
  end

  def mutation
    <<~GQL
      mutation updateUpNext($recipeIds: [ID!], $upNext: Float!) {
        updateUpNext(input: { recipeIds: $recipeIds, upNext: $upNext }) {
          success
          errors
          recipes {
            id
            upNext
          }
        }
      }
    GQL
  end
end
