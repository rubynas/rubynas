#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec => :compile)

desc 'Open a pry session preloaded with smartstat'
task :console do
  sh 'irb -rubygems -I ./lib -r rubynas'
end

desc 'Default: run specs.'
task :default => :spec
