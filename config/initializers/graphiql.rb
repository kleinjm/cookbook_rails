# frozen_string_literal: true

# See https://github.com/rmosolgo/graphiql-rails/blob/master/readme.md#configuration

# TODO: configure auth
# rubocop:disable Metrics/LineLength
GraphiQL::Rails.config.headers["Authorization"] = lambda { |_context|
  # TODO: configure auth. Hardcoded for now
  "Bearer eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI0YmEyNjVlZi1kNDRkLTQ2M2ItODFhNS1hZTczZjMzZmUzY2IiLCJzdWIiOiI0YzA3YzllMC02NTNhLTQ1ZWUtYjY1Yy1mOWQ4OTE1MmI1MzIiLCJzY3AiOiJ1c2VyIiwiYXVkIjpudWxsLCJpYXQiOjE1NjQyODIzMTUsImV4cCI6MTU4MDA2MDc5MX0.Wwm-pX-XY2QEI_Df_wn4bYpGsKRQMFfYl8kB6vdFhKY"
}
# rubocop:enable Metrics/LineLength
