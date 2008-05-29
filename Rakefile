require 'rubygems'
gem 'rspec'
require "spec/rake/spectask"

Spec::Rake::SpecTask.new :spec do |t|
  t.fail_on_error = false
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.verbose = false
end

task :default => :spec