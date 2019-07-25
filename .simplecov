# frozen_string_literal: true

SimpleCov.start "rails" do
  minimum_coverage 68

  # custom directories
  add_group "Graphql", "app/graphql"
  add_group "Queries", "app/queries"
  add_group "Services", "app/services"

  # skipped files and directories
  add_filter "app/channels"
  add_filter "app/jobs"
  add_filter "app/mailers"
end
