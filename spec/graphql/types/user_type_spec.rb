# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::UserType do
  it "returns the current user" do
    user = create(:user)
    variables = { "id" => user.gql_id }

    result = gql_query(
      query: query, variables: variables, user: user
    ).to_h.deep_symbolize_keys

    expect(result.dig(:data, :node, :id)).to eq(user.gql_id)
    expect(result[:errors]).to be_blank
  end

  def query
    <<~GQL
      query user($id: ID!) {
        node(id: $id) {
          ... on User {
            id
            firstName
            lastName
          }
        }
      }
    GQL
  end
end
