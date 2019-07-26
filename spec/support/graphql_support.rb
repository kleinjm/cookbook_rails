# frozen_string_literal: true

module GqlSupport
  def gql_query(query:, variables: {}, context: {}, user: nil)
    add_user(context: context, user: user)

    CookbookRailsSchema.execute(
      query,
      variables: variables.deep_stringify_keys,
      context: context
    )
  end

  private

  def add_user(context:, user:)
    return if user.blank?

    context[:current_user] = user
  end
end

RSpec.configure do |config|
  config.include GqlSupport, type: :gql
end
