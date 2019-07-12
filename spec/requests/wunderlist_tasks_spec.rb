# # frozen_string_literal: true

# frozen_string_literal: true

require "rails_helper"

describe "wunderlist endpoints" do
  describe "POST /wunderlist_tasks" do
    it "calls the interface and responds successfully" do
      sign_in_user
      recipe = create :recipe, :with_ingredient
      wl = instance_double WunderlistInterface
      expect(WunderlistInterface).to receive(:new).and_return(wl)
      expect(wl).to receive(:add_recipe).with(recipe: recipe, multiplier: 1).
        and_return(1)

      post wunderlist_tasks_path, params: { id: recipe.id, format: :json }

      expect(response).to be_successful
      expect(json_body[:success]).to be true
      expect(json_body[:task_count]).to eq 1
    end

    it "calls the interface with a multiplier and responds successfully" do
      sign_in_user
      recipe = create :recipe, :with_ingredient
      wl = instance_double WunderlistInterface
      expect(WunderlistInterface).to receive(:new).and_return(wl)
      expect(wl).to receive(:add_recipe).with(recipe: recipe, multiplier: 2).
        and_return(1)

      post wunderlist_tasks_path,
           params: { id: recipe.id, multiplier: 2, format: :json }

      expect(response).to be_successful
      expect(json_body[:success]).to be true
      expect(json_body[:task_count]).to eq 1
    end
  end
end
