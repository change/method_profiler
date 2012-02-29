require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run specs"
RSpec::Core::RakeTask.new { |t| t.rspec_opts = "--color" }

task :default => :spec
