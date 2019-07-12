# frozen_string_literal: true

#
#
# @example Adding a header to the request
#    config.headers["My-Header"] = -> (view_context) { "My-Value" }
#
# @return [Hash<String => Proc>] Keys are headers to include in GraphQL requests, values are `->(view_context) { ... }` procs to determin values

# TODO: configure auth
GraphiQL::Rails.config.headers["Authorization"] = lambda { |_context|
  # TODO: configure auth. Hardcoded for now
  "Bearer yJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJkMzdmYTAwYS05Y2E1LTRkOTMtYmJlYS1hYzRhNmFlOTFlMWIiLCJzdWIiOiI1Mzg2NThjMi04ZDEwLTRmNTItYTdjOS1iNzQxOTYyMzcwMDkiLCJzY3AiOiJ1c2VyIiwiYXVkIjpudWxsLCJpYXQiOjE1NjI4ODUwNTYsImV4cCI6MTU2Mjg4ODY1Nn0.WRaYTEpvbmOQJOtyhNNezi-3-1o6XIeGeuiUDoSzCRM"
}
