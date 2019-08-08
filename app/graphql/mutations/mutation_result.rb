# frozen_string_literal: true

module Mutations
  class MutationResult
    # can handle multiple objects
    def self.call(object = {}, success: true, errors: [])
      base_results = { success: success, errors: errors }
      return base_results if object.blank?

      key =
        if object.is_a?(Enumerable)
          object.first.class.name.downcase.pluralize
        else
          object.class.name.underscore
        end
      { key => object }.deep_symbolize_keys.merge(base_results)
    end
  end
end
