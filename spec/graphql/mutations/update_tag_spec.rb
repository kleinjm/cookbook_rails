# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::UpdateTag do
  it "updates the tag for the given user" do
    user = create(:user)
    tag = create(:tag, user: user)

    variables = { "tagId" => tag.gql_id, "name" => "My New Tag" }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :updateTag)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank

    tag.reload
    tag_result = result[:tag]
    expect(tag_result[:id]).to eq(tag.gql_id)
    expect(tag_result[:name]).to eq(tag.name)
  end

  def mutation
    <<~GQL
      mutation updateTag($tagId: ID!, $name: String!) {
        updateTag(input: { tagId: $tagId, name: $name }) {
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
