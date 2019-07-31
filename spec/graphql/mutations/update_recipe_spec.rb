# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::UpdateRecipe do
  it "updates the recipe" do
    Timecop.freeze do
      user = create(:user)
      recipe = create(:recipe, user: user)
      variables = {
        "recipeId" => recipe.gql_id,
        "cookTimeQuantity" => "20",
        "cookTimeUnit" => "minutes",
        "ingredients" => "1 cup Basil",
        "link" => "http://www.google.com",
        "name" => "My New Recipe",
        "description" => "Some cool description",
        "source" => "My cookbook, page 1",
        "steps" => "First step\n Second step",
        # "tag_ids" => nil,
        "upNext" => 1.0
      }

      result = gql_query(
        query: mutation, variables: variables, user: user
      ).to_h.deep_symbolize_keys.dig(:data, :updateRecipe)

      expect(result[:success]).to eq(true)
      expect(result[:errors]).to be_blank

      recipe.reload
      recipe_result = result[:recipe]
      expect(recipe_result[:id]).to eq(recipe.gql_id)
      expect(recipe_result[:name]).to eq(recipe.name)
      expect(recipe_result.dig(:ingredients, :nodes)).
        to eq([{ name: "Basil", quantity: 1.0, unit: "cup" }])
      expect(recipe_result[:stepList]).to eq(["First step", " Second step"])
      expect(recipe_result[:steps]).to eq("First step\n Second step")
      expect(recipe_result[:link]).to eq(variables["link"])
      expect(recipe_result[:cookTimeQuantity]).
        to eq(variables["cookTimeQuantity"])
      expect(recipe_result[:cookTimeUnit]).to eq(variables["cookTimeUnit"])
      expect(recipe_result.dig(:tags, :nodes)).to eq([])
      expect(recipe_result[:upNext]).to eq(variables["upNext"])
      expect(recipe_result[:description]).to eq(variables["description"])
      expect(recipe_result[:source]).to eq(variables["source"])
    end
  end

  it "does not allow updating if not signed in" do
    recipe = create(:recipe)
    variables = { "recipeId" => recipe.gql_id }

    result = gql_query(query: mutation, variables: variables).
             to_h.deep_symbolize_keys

    expect(result.dig(:errors, 0, :message)).to eq("User not signed in")
  end

  it "does not allow updating another user's recipe" do
    recipe = create(:recipe)
    variables = { "recipeId" => recipe.gql_id, "name" => "new name" }

    result = gql_query(
      query: mutation, variables: variables, user: create(:user)
    ).to_h.deep_symbolize_keys

    expect(result.dig(:data, :updateRecipe, :recipe, :name)).to be_nil
    expect(result.dig(:errors, 0, :message)).
      to eq("Unauthorized to change this object")
  end

  def mutation
    <<~GQL
      mutation updateRecipe(
        $recipeId: ID!,
        $cookTimeQuantity: String,
        $cookTimeUnit: String,
        $ingredients: String,
        $link: String,
        $name: String,
        $description: String,
        $source: String,
        $steps: String,
        $tagIds: [ID!]
        $upNext: Float,
      ) {
        updateRecipe(input: {
          recipeId: $recipeId,
          cookTimeQuantity: $cookTimeQuantity,
          cookTimeUnit: $cookTimeUnit,
          ingredients: $ingredients,
          link: $link,
          name: $name,
          description: $description,
          source: $source,
          steps: $steps,
          tagIds: $tagIds,
          upNext: $upNext,
        }) {
          recipe {
            cookTimeQuantity
            cookTimeUnit
            id
            link
            name
            description
            source
            stepList
            steps
            upNext
            ingredients {
              nodes {
                name
                quantity
                unit
              }
            }
            tags {
              nodes {
                id
                name
              }
            }
          }
          success
          errors
        }
      }
    GQL
  end
end
