require 'spec_helper'

profiler = MethodProfiler.new(Petition)

describe MethodProfiler do
  it "can be instantiated with an object to observe" do
    profiler.should be
  end

  it "finds all the object's instance methods" do
    profiler.observed_methods.sort.should == [:foo, :bar, :baz].sort
  end

  it "creates wrapper methods for each method in the object" do
    petition = Petition.new
    petition.should respond_to(:foo)
    petition.should respond_to(:foo_with_profiling)
    petition.should respond_to(:foo_without_profiling)
    petition.should_not respond_to(:foo_with_profiling_with_profiling)
  end
end
