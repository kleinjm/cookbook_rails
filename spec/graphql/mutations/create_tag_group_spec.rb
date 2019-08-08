# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateTagGroup do
  it "creates the tag group" do
    user = create(:user)

    variables = { "name" => "My New Tag Group" }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :createTagGroup)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank

    tag_group = user.tag_groups.first
    tag_result = result[:tagGroup]
    expect(tag_result[:id]).to eq(tag_group.gql_id)
    expect(tag_result[:name]).to eq(tag_group.name)
  end

  def mutation
    <<~GQL
      mutation createTagGroup($name: String!) {
        createTagGroup(input: { name: $name }) {
          tagGroup {
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
