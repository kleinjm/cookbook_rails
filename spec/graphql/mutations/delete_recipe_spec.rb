# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::DeleteRecipe do
  it "deletes the recipe" do
    user = create(:user)
    recipe = create(:recipe, user: user)
    variables = { "recipeId" => recipe.gql_id }

    result = gql_query(
      query: mutation, variables: variables, user: user
    ).to_h.deep_symbolize_keys.dig(:data, :deleteRecipe)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank
    expect(Recipe.count).to be_zero
  end

  it "does not allow deleting if not signed in" do
    recipe = create(:recipe)
    variables = { "recipeId" => recipe.gql_id }

    result = gql_query(query: mutation, variables: variables).
             to_h.deep_symbolize_keys

    expect(result.dig(:errors, 0, :message)).
      to eq(I18n.t("mutations.base_mutation.unauthorized_for_user"))
  end

  it "does not allow deleting another user's recipe" do
    recipe = create(:recipe)
    variables = { "recipeId" => recipe.gql_id, "name" => "new name" }

    result = gql_query(
      query: mutation, variables: variables, user: create(:user)
    ).to_h.deep_symbolize_keys

    expect(result.dig(:data, :deleteRecipe, :recipe, :name)).to be_nil
    expect(result.dig(:errors, 0, :message)).
      to eq(I18n.t("mutations.base_mutation.unauthorized_for_object"))
  end

  def mutation
    <<~GQL
      mutation deleteRecipe($recipeId: ID!) {
        deleteRecipe(input: { recipeId: $recipeId }) {
          success
          errors
        }
      }
    GQL
  end
end
