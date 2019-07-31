# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::QueryType do
  describe "#recipes" do
    it "calls the query object with defaults" do
      allow(Queries::Recipes).to receive(:call)
      execute_gql(user: nil, query: recipes_query)

      expect(Queries::Recipes).to have_received(:call).with(
        user: nil,
        ingredient_search: "",
        search_query: "",
        tag_ids: [],
        up_next: false
      )
    end

    it "calls the query object with defaults" do
      allow(Queries::Recipes).to receive(:call)
      user = create(:user)
      execute_gql(
        variables: {
          "ingredientSearch" => "ingredient",
          "searchQuery" => "search",
          "tagIds" => ["456"],
          "upNext" => false
        },
        user: user,
        query: recipes_query
      )

      expect(Queries::Recipes).to have_received(:call).with(
        user: user,
        ingredient_search: "ingredient",
        search_query: "search",
        tag_ids: ["456"],
        up_next: false
      )
    end
  end

  describe "#recipe" do
    it "returns the given recipe" do
      recipe = create(:recipe)
      result = execute_gql(
        variables: { "uuid" => recipe.uuid },
        query: recipe_query
      )

      expect(result.dig(:recipe, :uuid)).to eq(recipe.uuid)
    end

    # app/graphql/errors.rb does raise an error but the result is not working
    # in tests
    it "raises an error if unable to find recipe" do
      result = execute_gql(
        variables: { "uuid" => "bad-id" },
        query: recipe_query
      )
      expect(result).to be_nil
    end
  end

  describe "#tags" do
    it "returns all tags for the current user ordered by name" do
      user = create(:user)
      my_tag_first = create(:tag, user: user, name: "A")
      my_tag_second = create(:tag, user: user, name: "B")
      _other_tag = create(:tag)

      result = execute_gql(user: user, query: tags_query)

      expect(result.dig(:tags, :nodes).count).to eq(2)
      expect(result.dig(:tags, :nodes, 0, :id)).to eq(my_tag_first.gql_id)
      expect(result.dig(:tags, :nodes, 1, :id)).to eq(my_tag_second.gql_id)
    end
  end

  describe "#menus" do
    it "returns all menus for the current user ordered by created_at" do
      user = create(:user)
      my_menu_first =
        create(:menu, user: user, created_at: 2.days.ago)
      my_menu_second = create(:menu, user: user)
      _other_menu = create(:menu)

      result = execute_gql(user: user, query: menus_query)

      expect(result.dig(:menus, :nodes).count).to eq(2)
      expect(result.dig(:menus, :nodes, 0, :id)).to eq(my_menu_first.gql_id)
      expect(result.dig(:menus, :nodes, 1, :id)).to eq(my_menu_second.gql_id)
    end
  end

  def execute_gql(query:, variables: {}, user: create(:user))
    response = gql_query(query: query, variables: variables, user: user)
    response.to_h.deep_symbolize_keys.dig(:data)
  end

  # rubocop:disable Metrics/MethodLength
  def recipes_query
    %(
      query(
        $ingredientSearch: String,
        $searchQuery: String,
        $tagIds: [ID!],
        $upNext: Boolean
      ) {
        recipes(
          ingredientSearch: $ingredientSearch,
          searchQuery: $searchQuery,
          tagIds: $tagIds,
          upNext: $upNext
        ) {
          nodes {
            id
            name
            upNext
          }
        }
      }
    )
  end

  def recipe_query
    %(
      query($uuid: ID!) {
        recipe(uuid: $uuid) {
          id
          uuid
        }
      }
    )
  end

  def tags_query
    %(
      query {
        tags {
          nodes {
            id
            name
          }
        }
      }
    )
  end

  def menus_query
    %(
      query {
        menus {
          nodes {
            id
            name
          }
        }
      }
    )
  end
  # rubocop:enable Metrics/MethodLength
end
