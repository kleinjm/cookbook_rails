# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateRecipe do
  it "creates the recipe for the given user" do
    Timecop.freeze do
      user = create(:user)

      variables = {
        "cookTimeQuantity" => "20",
        "cookTimeUnit" => "minutes",
        "ingredients" => "1 cup Basil",
        "link" => "http://www.google.com",
        "name" => "My New Recipe",
        "description" => "Some cool description",
        "source" => "My cookbook, page 1",
        "steps" => "First step\n Second step",
        # "tag_ids" => nil,
        "upNext" => 1.0,
        "timesCooked" => 3
      }

      result = gql_query(
        query: mutation,
        variables: variables,
        user: user
      ).to_h.deep_symbolize_keys.dig(:data, :createRecipe)

      expect(result[:success]).to eq(true)
      expect(result[:errors]).to be_blank

      recipe = user.recipes.first
      recipe_result = result[:recipe]
      expect(recipe_result[:id]).to eq(recipe.gql_id)
      expect(recipe_result[:name]).to eq(recipe.name)
      expect(recipe_result[:ingredients][:nodes]).
        to eq([{ name: "Basil", quantity: 1.0, unit: "cup" }])
      expect(recipe_result[:stepList]).to eq(["First step", " Second step"])
      expect(recipe_result[:steps]).to eq("First step\n Second step")
      expect(recipe_result[:link]).to eq(variables["link"])
      expect(recipe_result[:cookTimeQuantity]).
        to eq(variables["cookTimeQuantity"])
      expect(recipe_result[:cookTimeUnit]).to eq(variables["cookTimeUnit"])
      expect(recipe_result[:tags][:nodes]).to eq([])
      expect(recipe_result[:upNext]).to eq(variables["upNext"])
      expect(recipe_result[:timesCooked]).to eq(variables["timesCooked"])
      expect(recipe_result[:description]).to eq(variables["description"])
      expect(recipe_result[:source]).to eq(variables["source"])
    end
  end

  it "does not allow creating if not signed in" do
    variables = { "name" => "Test" }

    result = gql_query(query: mutation, variables: variables).
             to_h.deep_symbolize_keys

    expect(result.dig(:errors, 0, :message)).to eq("User not signed in")
  end

  def mutation
    <<~GQL
      mutation createRecipe(
        $name: String!,
        $cookTimeQuantity: String,
        $cookTimeUnit: String,
        $ingredients: String,
        $link: String,
        $description: String,
        $source: String,
        $steps: String,
        $tagIds: [ID!],
        $upNext: Float,
        $timesCooked: Int
      ) {
        createRecipe(input: {
          name: $name,
          cookTimeQuantity: $cookTimeQuantity,
          cookTimeUnit: $cookTimeUnit,
          ingredients: $ingredients,
          link: $link,
          description: $description,
          source: $source,
          steps: $steps,
          tagIds: $tagIds,
          upNext: $upNext,
          timesCooked: $timesCooked
        }) {
          recipe {
            id
            name
            ingredients {
              nodes {
                name
                quantity
                unit
              }
            }
            stepList
            steps
            link
            cookTimeQuantity
            cookTimeUnit
            tags {
              nodes {
                id
                name
              }
            }
            upNext
            timesCooked
            description
            source
          }
          success
          errors
        }
      }
    GQL
  end
end
