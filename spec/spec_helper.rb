require "simplecov"
SimpleCov.start

$:.unshift(File.expand_path("../../lib", __FILE__))
require "method_profiler"

RSpec.configure do |config|
  config.around do |example|
    load File.expand_path("../support/petition.rb", __FILE__)
    example.call
    Object.send(:remove_const, :Petition)
  end
end
