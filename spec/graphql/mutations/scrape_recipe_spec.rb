# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::ScrapeRecipe do
  it "scrapes a new recipe" do
    recipe = Recipe.new(name: "New recipe")
    scraper = instance_double RecipeScraper, recipe: recipe
    allow(RecipeScraper).to receive(:new).and_return(scraper)

    result = double :result, errors: nil
    allow(scraper).to receive(:scrape).and_return(result)

    variables = { "url" => "www.test.com" }
    response = gql_query(query: mutation, variables: variables).
               to_h.deep_symbolize_keys.dig(:data, :scrapeRecipe)

    expect(response.dig(:recipe, :name)).to eq(recipe.name)
    expect(response[:errors]).to be_empty

    expect(RecipeScraper).to have_received(:new).with(an_instance_of(Recipe))
    expect(scraper).to have_received(:scrape).with(variables["url"])
  end

  it "scrapes an existing recipe" do
    recipe = create(:recipe)
    scraper = instance_double RecipeScraper, recipe: recipe
    allow(RecipeScraper).to receive(:new).and_return(scraper)

    result = double :result, errors: nil
    allow(scraper).to receive(:scrape).and_return(result)

    variables = { "url" => "www.test.com", "recipeId" => recipe.gql_id }
    response = gql_query(query: mutation, variables: variables).
               to_h.deep_symbolize_keys.dig(:data, :scrapeRecipe)

    expect(response.dig(:recipe, :name)).to eq(recipe.name)
    expect(response[:errors]).to be_empty

    expect(RecipeScraper).to have_received(:new).with(recipe)
    expect(scraper).to have_received(:scrape).with(variables["url"])
  end

  it "returns errors when unable to scrape" do
    recipe = Recipe.new(name: "test")
    scraper = instance_double RecipeScraper, recipe: recipe
    allow(RecipeScraper).to receive(:new).and_return(scraper)

    result = double :result, errors: "Something went wrong"
    allow(scraper).to receive(:scrape).and_return(result)

    variables = { "url" => "www.test.com" }
    response = gql_query(query: mutation, variables: variables).
               to_h.deep_symbolize_keys.dig(:data, :scrapeRecipe)

    expect(response.dig(:recipe, :name)).to eq(recipe.name)
    expect(response[:errors]).to eq(["Something went wrong"])
  end

  def mutation
    <<~GQL
      mutation scrapeRecipe(
        $recipeId: ID,
        $url: String!,
      ) {
        scrapeRecipe(input: {
          recipeId: $recipeId,
          url: $url,
        }) {
          recipe {
            name
          }
          errors
        }
      }
    GQL
  end
end
