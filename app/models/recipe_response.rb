# frozen_string_literal: true

class RecipeResponse < BaseResponse
  attr_accessor :recipe

  def initialize(recipe:, success:, errors:)
    super(success: success, errors: errors)
    @recipe = ActiveModelSerializers::SerializableResource.new(recipe)
  end
end
