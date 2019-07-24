# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::UpdateMenu do
  it "updates the menu for the given user" do
    user = create(:user)
    menu = create(:menu, user: user)

    variables = {
      "menuId" => menu.gql_id,
      "name" => "My New Menu",
      "description" => "Description!!"
    }

    result = gql_query(
      query: mutation,
      variables: variables,
      user: user
    ).to_h.deep_symbolize_keys.dig(:data, :updateMenu)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank

    menu.reload
    menu_result = result[:menu]
    expect(menu_result[:id]).to eq(menu.gql_id)
    expect(menu_result[:name]).to eq(menu.name)
    expect(menu_result[:description]).to eq(menu.description)
  end

  def mutation
    <<~GQL
      mutation updateMenu($menuId: ID!, $name: String, $description: String) {
        updateMenu(input: {
          menuId: $menuId, name: $name, description: $description
        }) {
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
