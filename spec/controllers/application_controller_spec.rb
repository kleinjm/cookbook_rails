# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  class MockController < ApplicationController
    def index
      respond_to { |format| format.json { render json: { success: true } } }
    end
  end

  before do
    routes.draw { get "index" => "mock#index" }
    @controller = MockController.new
  end

  after do
    Rails.application.reload_routes!
  end

  describe "#index" do
    it "renders empty content" do
      expect(response.body).to eq("")
    end
  end

  describe "before_action #handle_html_requests" do
    it "renders the layout only for html requests" do
      get :index

      expect(response).to be_successful
      expect(response).to render_template("layouts/application")
    end

    it "renders ok for requests other than html" do
      get :index, format: :json

      expect(response).to be_successful
      expect(json_body[:success]).to eq(true)
    end
  end
end
