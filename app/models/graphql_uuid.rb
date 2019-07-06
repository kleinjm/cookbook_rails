# frozen_string_literal: true

class GraphqlUuid
  class << self
    def encode(object)
      "#{object.class.name}/#{object.id}"
    end

    def decode(gql_id)
      gql_id.split("/")
    end
  end
end
