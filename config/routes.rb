# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api, defaults: {format: :json} do
    devise_for :users,
      controllers: { sessions: "sessions", registrations: "registrations" },
      defaults: { format: :json }

    devise_scope :user do
      get "users/current", to: "sessions#show"
    end
  end
end
