# frozen_string_literal: true

SimpleCov.start "rails" do
  minimum_coverage 89.19

  # custom directories
  add_group "Graphql", "app/graphql"
  add_group "Queries", "app/queries"
  add_group "Services", "app/services"

  # skipped files and directories
  add_filter "app/channels"
  add_filter "app/jobs"
  add_filter "app/mailers"
  add_filter "lib/tasks/one_offs"
end
