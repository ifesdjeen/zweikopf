#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

desc 'Default: run the specs and features.'
task :default => 'spec:all'

namespace :spec do
  desc "Run all specs"
  RSpec::Core::RakeTask.new('all') do |t|
    # t.expect_with(:rspec) { |c| c.syntax = :should }
    t.pattern = 'spec/{**/*_spec.rb}'
  end
end
