# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read("./.ruby-version").strip

gem "rails", "~> 5.2.3"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "redis", "~> 4.0"
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  gem "pry"
  gem "pry-nav"
  gem "rspec-rails"
end

group :development do
  gem "jcop", "~> 0.3.0", git: "https://github.com/kleinjm/jcop"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "rubocop-performance"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "factory_bot"
end
