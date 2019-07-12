# frozen_string_literal: true

module ApiHelpers
  def json_body
    json = JSON.parse(response.body)
    json.is_a?(Hash) ? json.with_indifferent_access : json # could be an array
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :controller
  config.include ApiHelpers, type: :request
end
