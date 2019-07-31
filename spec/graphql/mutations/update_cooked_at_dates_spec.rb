# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::UpdateCookedAtDates do
  it "calls the date changer" do
    user = create(:user)
    recipe = create(:recipe, user: user)
    amount = 3

    variables = { "recipeUuid" => recipe.uuid, "amount" => amount }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :updateCookedAtDates)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank

    expect(result.dig(:recipe, :cookedAtDates).length).to eq(amount)
    expect(result.dig(:recipe, :timesCooked)).to eq(amount)

    recipe.reload
    expect(Date.parse(recipe.cooked_at_dates.first)).to be_a(Date)
    expect(recipe.times_cooked).to eq(amount)
  end

  def mutation
    <<~GQL
      mutation updateCookedAtDates($recipeUuid: ID!, $amount: Int!) {
        updateCookedAtDates(input: { recipeUuid: $recipeUuid, amount: $amount }) {
          success
          errors
          recipe {
            id
            uuid
            cookedAtDates
            timesCooked
          }
        }
      }
    GQL
  end
end
