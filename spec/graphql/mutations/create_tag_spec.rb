# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateTag do
  it "creates the tag for the given user" do
    user = create(:user)

    variables = { "name" => "My New Tag" }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :createTag)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank

    tag = user.tags.first
    tag_result = result[:tag]
    expect(tag_result[:id]).to eq(tag.gql_id)
    expect(tag_result[:name]).to eq(tag.name)
  end

  def mutation
    <<~GQL
      mutation createTag($name: String!) {
        createTag(input: { name: $name }) {
          tag {
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
