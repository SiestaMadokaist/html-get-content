require "rake/testtask"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:test) do |test|
  test.pattern = ENV["TESTS"] || "test/**/*_test.rb"
  test.rspec_opts = "--format documentation"
end

task default: :test
