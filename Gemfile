# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read("./.ruby-version").strip

gem "bootsnap", ">= 1.1.0", require: false
gem "devise"
gem "devise-jwt"
gem "jbuilder"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "rack-cors"
gem "rails", "~> 5.2.3"
gem "redis", "~> 4.0"

group :development, :test do
  gem "dotenv-rails", require: "dotenv/rails-now"
  gem "pry"
  gem "pry-nav"
  gem "rspec-rails"
end

group :development do
  gem "jcop", "~> 0.3.0", git: "https://github.com/kleinjm/jcop"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "pre-commit"
  gem "rubocop-performance"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "factory_bot"
end
