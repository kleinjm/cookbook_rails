# frozen_string_literal: true

module GqlSupport
  def gql_query(query:, variables: {}, context: {}, user: nil)
    add_user(context: context, user: user)

    query = GraphQL::Query.new(
      CookbookRailsSchema,
      query,
      variables: variables.deep_stringify_keys,
      context: context
    )

    query.result if query.valid?
  end

  private

  def add_user(context:, user:)
    return if user.blank?

    context[:current_user] = user.users&.first
  end
end

RSpec.configure do |config|
  config.include GqlSupport, type: :gql
end
