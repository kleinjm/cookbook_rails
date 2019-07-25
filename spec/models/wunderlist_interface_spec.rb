# frozen_string_literal: true

require "rails_helper"

RSpec.describe WunderlistInterface do
  describe "#add_recipe" do
    it "adds the recipe to wunderlist" do
      stub_get_list

      recipe = instance_double Recipe
      expect(recipe).to receive(:ingredients_full_names).with(multiplier: 1).
        and_return(["1 cup test"])
      stub_create_task("1 cup test")

      expect(WunderlistInterface.new.add_recipe(recipe: recipe)).to eq 1
    end

    it "adds the recipe with multiplier to wunderlist" do
      stub_get_list

      recipe = instance_double Recipe
      expect(recipe).to receive(:ingredients_full_names).with(multiplier: 2).
        and_return(["2 cup test"])
      stub_create_task("2 cup test")

      expect(WunderlistInterface.new.add_recipe(recipe: recipe, multiplier: 2)).
        to eq 1
    end
  end

  def stub_get_list
    stub_request(:get, "https://a.wunderlist.com/api/v1/lists").
      with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "User-Agent" => "Ruby",
          "X-Access-Token" => x_access_token,
          "X-Client-Id" => "cf59f8dece4c5b479ce1"
        }
      ).to_return(status: 200, body: {}.to_json, headers: {})
  end

  def stub_create_task(task)
    body = {
      "id" => nil,
      "list_id" => nil,
      "title" => task,
      "revision" => nil,
      "assignee_id" => nil,
      "created_at" => nil,
      "completed" => false,
      "completed_at" => nil,
      "completed_by_id" => nil,
      "recurrence_type" => nil,
      "recurrence_count" => nil,
      "due_date" => nil,
      "starred" => nil
    }

    stub_request(:post, "https://a.wunderlist.com/api/v1/tasks").
      with(
        body: body.to_json,
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Encoding" => "UTF-8",
          "Content-Type" => "application/json",
          "User-Agent" => "Ruby",
          "X-Access-Token" => x_access_token,
          "X-Client-Id" => "cf59f8dece4c5b479ce1"
        }
      ).to_return(status: 200, body: {}.to_json, headers: {})
  end

  def x_access_token
    "cbd92fc07738d207453ff4917e409b8541c77bd5d90d874726de695088d9"
  end
end
