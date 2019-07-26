# frozen_string_literal: true

class CookbookRailsSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # GraphQL::Batch setup. Must be after `mutation`
  use GraphQL::Batch

  def self.id_from_object(object, _type_definition, _query_ctx)
    # Call your application's UUID method here
    # It should return a string
    GraphqlUuid.encode(object)
  end

  def self.object_from_id(id, _query_ctx)
    class_name, item_id = GraphqlUuid.decode(id)
    # "Post" => Post.find(item_id)
    Object.const_get(class_name).find(item_id)
  end

  # You'll also need to define `resolve_type` for
  # telling the schema what type Relay `Node` objects are
  def self.resolve_type(_type, obj, _ctx)
    "Types::#{obj.class.name}Type".constantize
  rescue NameError
    raise("Unexpected object: #{obj}")
  end

  def self.unauthorized_object(error)
    raise GraphQL::ExecutionError,
          "An object of type #{error.type.graphql_name} was hidden due " \
          "to permissions"
  end
end

require_relative "./errors"
