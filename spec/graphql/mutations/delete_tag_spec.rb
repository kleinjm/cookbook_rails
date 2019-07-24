# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::DeleteTag do
  it "deletes the tag" do
    user = create(:user)
    tag = create(:tag, user: user)
    variables = { "tagId" => tag.gql_id }

    result = gql_query(
      query: mutation, variables: variables, user: user
    ).to_h.deep_symbolize_keys.dig(:data, :deleteTag)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank
    expect(Tag.count).to be_zero
  end

  def mutation
    <<~GQL
      mutation deleteTag($tagId: ID!) {
        deleteTag(input: { tagId: $tagId }) {
          success
          errors
        }
      }
    GQL
  end
end
