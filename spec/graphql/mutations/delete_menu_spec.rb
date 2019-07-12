# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::DeleteMenu do
  it "deletes the menu" do
    user = create(:user, :user)
    menu = create(:menu, user: user)
    variables = { "menuId" => menu.gql_id }

    result = gql_query(
      query: mutation, variables: variables, user: user
    ).to_h.deep_symbolize_keys.dig(:data, :deleteMenu)

    expect(result[:success]).to eq(true)
    expect(result[:errors]).to be_blank
    expect(Menu.count).to be_zero
  end

  def mutation
    <<~GQL
      mutation deleteMenu($menuId: ID!) {
        deleteMenu(input: { menuId: $menuId }) {
          success
          errors
        }
      }
    GQL
  end
end
