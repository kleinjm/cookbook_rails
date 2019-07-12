# frozen_string_literal: true

module Mutations
  class MutationResult
    def self.call(object = {}, success: true, errors: [])
      base_results = { success: success, errors: errors }
      return base_results if object.blank?

      key = object.class.name.downcase
      { key => object }.deep_symbolize_keys.merge(base_results)
    end
  end
end
