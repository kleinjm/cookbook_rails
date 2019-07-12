# frozen_string_literal: true

class BaseResponse
  attr_accessor :success, :errors

  def initialize(success:, errors: [])
    @success = success
    @errors = errors
  end
end
