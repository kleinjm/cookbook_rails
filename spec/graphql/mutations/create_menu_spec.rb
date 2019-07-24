# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::CreateMenu do
  it "creates the menu for the given user" do
    user = create(:user)

    variables = { "name" => "My New Menu", "description" => "Description" }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :createMenu)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank

    menu = user.menus.first
    menu_result = result[:menu]
    expect(menu_result[:id]).to eq(menu.gql_id)
    expect(menu_result[:name]).to eq(menu.name)
    expect(menu_result[:description]).to eq(menu.description)
  end

  def mutation
    <<~GQL
      mutation createMenu($name: String!, $description: String) {
        createMenu(input: { name: $name, description: $description }) {
          menu {
            id
            name
            description
          }
          success
          errors
        }
      }
    GQL
  end
end
