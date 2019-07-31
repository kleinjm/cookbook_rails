# frozen_string_literal: true

class CookedAtDateChanger
  def initialize(recipe:, amount:)
    @recipe = recipe
    @amount = amount
  end

  def call
    return zero_amount_error if amount.zero?
    if amount.negative? && amount.abs > recipe.cooked_at_dates.count
      return invalid_decrement_error
    end

    adjust_amount
    recipe_response
  end

  private

  attr_reader :recipe, :amount

  def adjust_amount
    if amount.positive?
      increment_cooked_at_dates
    else
      recipe.cooked_at_dates.pop(amount.abs)
    end
    recipe.save
  end

  def increment_cooked_at_dates
    recipe.cooked_at_dates += Array.new(amount) { Time.current.to_date }
  end

  def recipe_response
    {
      recipe: recipe,
      success: recipe.errors.blank?,
      errors: recipe.errors
    }
  end

  def zero_amount_error
    base_error_fields.merge(errors: ["Must provide a non-zero integer"])
  end

  def invalid_decrement_error
    base_error_fields.merge(
      errors: ["Cannot decrement cooked_at_dates more than exist"]
    )
  end

  def base_error_fields
    {
      recipe: recipe,
      success: false
    }
  end
end
