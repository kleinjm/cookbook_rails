# frozen_string_literal: true

namespace :recipes do
  task migrate_step_and_ingredients: :environment do
    StepMigrator.new.migrate
  end
end
