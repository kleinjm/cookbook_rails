# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateRecipe do
  it "creates the recipe for the given user" do
    Timecop.freeze do
      user = create(:user, :user)

      variables = {
        # "category_ids" => nil,
        "cookTimeQuantity" => "20",
        "cookTimeUnit" => "minutes",
        "ingredients" => "1 cup Basil",
        "link" => "www.google.com",
        "name" => "My New Recipe",
        "notes" => "Some cool notes",
        "source" => "My cookbook, page 1",
        "stepText" => "First step\n Second step",
        # "tag_ids" => nil,
        "thisWeek" => 1.0,
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
      expect(recipe_result[:ingredients]).
        to eq([{ name: "Basil", quantity: 1.0, unit: "cup" }])
      expect(recipe_result[:stepList]).to eq(["First step", " Second step"])
      expect(recipe_result[:stepText]).to eq("First step\n Second step")
      expect(recipe_result[:link]).to eq(variables["link"])
      expect(recipe_result[:cookTimeQuantity]).
        to eq(variables["cookTimeQuantity"])
      expect(recipe_result[:cookTimeUnit]).to eq(variables["cookTimeUnit"])
      expect(recipe_result[:tags]).to eq([])
      expect(recipe_result[:thisWeek]).to eq(variables["thisWeek"])
      expect(recipe_result[:timesCooked]).to eq(variables["timesCooked"])
      expect(recipe_result[:notes]).to eq(variables["notes"])
      expect(recipe_result[:source]).to eq(variables["source"])
      expect(recipe_result[:categories]).to eq([])
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
        $categoryIds: [ID!],
        $cookTimeQuantity: String,
        $cookTimeUnit: String,
        $ingredients: String,
        $link: String,
        $notes: String,
        $source: String,
        $stepText: String,
        $tagIds: [ID!],
        $thisWeek: Float,
        $timesCooked: Int
      ) {
        createRecipe(input: {
          name: $name,
          categoryIds: $categoryIds,
          cookTimeQuantity: $cookTimeQuantity,
          cookTimeUnit: $cookTimeUnit,
          ingredients: $ingredients,
          link: $link,
          notes: $notes,
          source: $source,
          stepText: $stepText,
          tagIds: $tagIds,
          thisWeek: $thisWeek,
          timesCooked: $timesCooked
        }) {
          recipe {
            id
            name
            ingredients {
              name
              quantity
              unit
            }
            stepList
            stepText
            link
            cookTimeQuantity
            cookTimeUnit
            tags {
              id
              name
            }
            thisWeek
            timesCooked
            notes
            source
            categories {
              id
              name
            }
          }
          success
          errors
          errorAttrs {
            attribute
            messages
          }
        }
      }
    GQL
  end
end
