# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::TagGroupType do
  # TODO: Fix! There is something wrong with how types are being loaded. If
  # the following is added to the query_type then the TagGroup works in the
  # schema and displays in the docs.
  #
  # field :tag_groups, TagGroupType.connection_type, null: false
  # def tag_groups
  #   TagGroup.where(user: context[:current_user]).order(:name)
  # end

  xit "returns the tag group type with tags" do
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
      to eq(group.ingredients.first.name)
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
              id
              name
            }
          }
        }
      }
    GQL
  end
end
