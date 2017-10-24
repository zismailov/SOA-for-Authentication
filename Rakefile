require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "active_record"

RSpec::Core::RakeTask.new(:spec)

namespace :db do
  desc "Create the tables"
  task :migrate do
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: "db/test.sqlite3"
    )
    ActiveRecord::Migrator.migrate(File.expand_path('../lib/cas/migrations', __FILE__))
  end
end

task :default => :spec
