# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::RecipeType do
  it "returns the recipe" do
    user = create(:user)
    recipe = create(
      :recipe,
      :with_ingredient,
      :with_cooked_at_dates,
      :with_steps,
      cooked_at_count: 2
    )

    variables = { "id" => recipe.gql_id }

    result = gql_query(
      query: query,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :node)

    expect(result[:id]).to eq(recipe.gql_id)
    expect(result[:uuid]).to eq(recipe.uuid)
    expect(result[:name]).to eq(recipe.name)
    expect(result.dig(:ingredients, :nodes, 0, :name)).
      to eq(recipe.ingredients.first.name)
    expect(result[:stepList]).to eq(recipe.step_list)
    expect(result[:steps]).to eq(recipe.steps)

    expect(result[:cookedAtDates].count).to eq(2)
    expect(result[:timesCooked]).to eq(2)
    expect(result[:lastCookedAt]).to eq(recipe.last_cooked_at)

    expect(result[:createdAt]).to_not be_nil
    expect(result[:updatedAt]).to_not be_nil
  end

  def query
    <<~GQL
      query($id: ID!) {
        node(id: $id) {
          ... on Recipe {
            id
            uuid
            name
            ingredients {
              nodes {
                id
                name
                quantity
                unit
              }
            }
            stepList
            link
            tags {
              nodes {
                id
                name
              }
            }
            upNext
            source
            createdAt
            updatedAt
            description
            cookedAtDates
            timesCooked
            lastCookedAt
          }
        }
      }
    GQL
  end
end
