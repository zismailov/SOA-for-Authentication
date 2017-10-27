# frozen_string_literal: true

ENV['CAS_ENV'] ||= 'development'

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'active_record'

RSpec::Core::RakeTask.new(:spec)

namespace :db do
  desc 'Migrate the database'
  task :migrate do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: "db/#{ENV['CAS_ENV']}.sqlite3"
    )
    ActiveRecord::Migrator.migrate(File.expand_path('../lib/cas/migrations', __FILE__))
  end

  desc 'Rollback last migration'
  task :rollback do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: "db/#{ENV['CAS_ENV']}.sqlite3"
    )
    ActiveRecord::Migrator.rollback(File.expand_path('../lib/cas/migrations', __FILE__))
  end
end

task default: :spec
