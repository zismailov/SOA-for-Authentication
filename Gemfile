# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'activerecord'
gem 'sinatra'

group :development do
  gem 'pry'
  gem 'rubocop', require: false
  gem 'sqlite3'
end

group :test do
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
end
# Specify your gem's dependencies in cas.gemspec
gemspec
