# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read("./.ruby-version").strip

gem "airbrake", "~> 5.0"
gem "bootsnap", ">= 1.1.0", require: false
gem "coffee-rails"
gem "devise"
gem "devise-jwt"
gem "graphiql-rails"
gem "graphql"
gem "graphql-batch" # TODO: check out and wire up all the graphql gems
gem "graphql-errors"
gem "graphql-guard"
gem "graphql-preload"
gem "ingreedy"
gem "jbuilder"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rack-cors"
gem "rails", "~> 5.2.3"
gem "redis", "~> 4.0"
gem "sass-rails"
gem "uglifier"
gem "validate_url"
gem "wunderlist-api", "1.3.0", git: "https://github.com/kleinjm/wunderlist-api"

group :development, :test do
  gem "bullet"
  gem "dotenv-rails", require: "dotenv/rails-now"
  gem "pry-nav"
  gem "pry-rails"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "overcommit"
  gem "pre-commit"
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-rspec", require: false
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "hashdiff", [">= 1.0.0.beta1", "< 2.0.0"]
  gem "rails-controller-testing"
  gem "rspec-graphql_matchers" # TODO: wire up all the graphql gems
  gem "rspec-rails"
  gem "shoulda"
  gem "shoulda-matchers", "~> 3.1.2"
  gem "simplecov", require: false
  gem "simplecov-lcov"
  gem "timecop"
  gem "undercover"
  gem "webmock"
end
