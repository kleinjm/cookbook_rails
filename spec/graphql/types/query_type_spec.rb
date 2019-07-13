# frozen_string_literal: true

require "rails_helper"

RSpec.describe Types::QueryType do
  describe "#recipes" do
    it "calls the query object with defaults" do
      allow(Queries::Recipes).to receive(:call)
      execute_gql(user: nil, query: recipe_query)

      expect(Queries::Recipes).to have_received(:call).with(
        user: nil,
        ingredient_search: "",
        last_cooked: 0,
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
          "lastCooked" => 10,
          "searchQuery" => "search",
          "tagIds" => ["456"],
          "upNext" => false
        },
        user: user,
        query: recipe_query
      )

      expect(Queries::Recipes).to have_received(:call).with(
        user: user,
        ingredient_search: "ingredient",
        last_cooked: 10,
        search_query: "search",
        tag_ids: ["456"],
        up_next: false
      )
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

  describe "#user_by_auth_token_query" do
    it "returns the user found by auth token" do
      user = create(:user, :user)

      result = execute_gql(
        user: user,
        query: user_by_auth_token_query,
        variables: {
          "token" => user.users.first.authentication_token
        }
      )

      expect(result.dig(:userByAuthToken, :id)).
        to eq(user.users.first.gql_id)
      expect(result.dig(:userByAuthToken, :authenticationToken)).
        to eq(user.users.first.authentication_token)
    end
  end

  def execute_gql(query:, variables: {}, user: create(:user, :user))
    response = gql_query(query: query, variables: variables, user: user)
    response.to_h.deep_symbolize_keys.dig(:data)
  end

  # rubocop:disable Metrics/MethodLength
  def recipe_query
    %(
      query(
        $ingredientSearch: String,
        $lastCooked: Int,
        $searchQuery: String,
        $tagIds: [ID!],
        $upNext: Boolean
      ) {
        recipes(
          ingredientSearch: $ingredientSearch,
          lastCooked: $lastCooked,
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

  def tags_query
    %(
      query {
        tags {
          nodes {
            id
            name
            recipeCount
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

  def user_by_auth_token_query
    %(
      query userByAuthToken($token: String!) {
        userByAuthToken(authenticationToken: $token) {
          id
          firstName
          lastName
          authenticationToken
        }
      }
    )
  end
  # rubocop:enable Metrics/MethodLength
end
