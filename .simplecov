# frozen_string_literal: true

SimpleCov.start "rails" do
  add_group "Graphql", "app/graphql"
  add_group "Serializers", "app/serializers"
  add_group "Services", "app/services"
end
