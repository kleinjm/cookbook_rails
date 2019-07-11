# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read("./.ruby-version").strip

gem "bootsnap", ">= 1.1.0", require: false
gem "coffee-rails"
gem "devise"
gem "devise-jwt"
gem "graphiql-rails"
gem "graphql"
# TODO: check out and wire up all the graphql gems
gem "graphql-batch"
gem "graphql-guard"
gem "graphql-preload"
gem "jbuilder"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rack-cors"
gem "rails", "~> 5.2.3"
gem "redis", "~> 4.0"
gem "sass-rails"
gem "uglifier"
gem "validate_url"

group :development, :test do
  gem "dotenv-rails", require: "dotenv/rails-now"
  gem "pry"
  gem "pry-nav"
  gem "rspec-rails"
end

group :development do
  gem "brakeman"
  gem "bullet"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "pre-commit"
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "factory_bot"
  # TODO: check out and wire up all the graphql gems
  gem "rspec-graphql_matchers"
  gem "simplecov", require: false
end
