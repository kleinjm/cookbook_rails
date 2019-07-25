# frozen_string_literal: true

class GraphqlUuid
  class << self
    def encode(object)
      raise ArgumentError, "No id provided" if object&.id.blank?

      "#{object.class.name}/#{object.id}"
    end

    def decode(gql_id)
      result = gql_id.split("/")

      # ie. "User/abc-123"
      return result if result.count == 2

      raise ArgumentError, "Invalid id provided"
    end
  end
end
