# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::UserType do
  it "returns the user with the given id" do
    user = create(:user)
    variables = { "id" => user.gql_id }

    result = gql_query(
      query: query, variables: variables, user: user
    ).to_h.deep_symbolize_keys.dig(:data, :node)

    expect(result[:id]).to eq(user.gql_id)
    expect(result[:firstName]).to eq(user.first_name)
    expect(result[:lastName]).to eq(user.last_name)
    expect(result[:email]).to eq(user.email)
    expect(result.dig(:recipes, :nodes)).to eq([])
  end

  it "does not return protected fields for the non-owner" do
    user = create(:user)
    non_owner = create(:user)
    variables = { "id" => user.gql_id }

    result = gql_query(
      query: query, variables: variables, user: non_owner
    ).to_h.deep_symbolize_keys#.dig(:data, :node)

    expect(result.dig(:data, :node)).to be_nil
    email_error = result.dig(:errors, 0)
    # TODO: finish testing
    expect(email_error[:path]).to eq(["node", "email"])
    expect(email_error[:message]).to eq("Unable to access email of different account")
  end

  def query
    <<~GQL
      query user($id: ID!) {
        node(id: $id) {
          ... on User {
            id
            firstName
            lastName
            email
            recipes {
              nodes {
                id
                name
              }
            }
          }
        }
      }
    GQL
  end
end
