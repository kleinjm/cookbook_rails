# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::TagGroupType do
  it "returns the tag group type with tags" do
    user = create(:user)
    group = create(:tag_group, :with_tags)

    variables = { "id" => group.gql_id }

    result = gql_query(
      query: query,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :node)

    expect(result[:id]).to eq(group.gql_id)
    expect(result[:uuid]).to eq(group.uuid)
    expect(result[:name]).to eq(group.name)
    expect(result.dig(:tags, :nodes, 0, :name)).
      to eq(group.tags.first.name)
  end

  def query
    <<~GQL
      query($id: ID!) {
        node(id: $id) {
          ... on TagGroup {
            id
            uuid
            name
            tags {
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
