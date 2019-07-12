# frozen_string_literal: true

class IngredientResponse < BaseResponse
  attr_accessor :ingredient

  def initialize(ingredient:, success:, errors:)
    super(success: success, errors: errors)
    @ingredient = ActiveModelSerializers::SerializableResource.new(ingredient)
  end
end
