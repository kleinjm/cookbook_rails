# frozen_string_literal: true

namespace :one_offs do
  desc "Raise error to test out error logging tool"
  task raise_error: :environment do
    raise StandardError, details: "These are some deets"
  end
end
