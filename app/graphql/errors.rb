# frozen_string_literal: true

# :nocov:
GraphQL::Errors.configure(CookbookRailsSchema) do
  rescue_from ActiveRecord::RecordNotFound do |exception|
    GraphQL::ExecutionError.new(exception)
  end

  rescue_from ActiveRecord::RecordInvalid do |exception|
    GraphQL::ExecutionError.
      new(exception.record.errors.full_messages.join("\n"))
  end
end
# :nocov:
