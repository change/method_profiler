require 'spec_helper'

profiler = MethodProfiler.new(Petition)

describe MethodProfiler do
  it "can be instantiated with an object to observe" do
    profiler.should be_true
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

  describe "#profile" do
    it "adds a new record for the method call" do
      petition = Petition.new
      petition.foo
      profiler.data[:foo].size.should == 1
    end
  end
end
