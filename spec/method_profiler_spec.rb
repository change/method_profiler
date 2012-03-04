require 'spec_helper'

profiler = MethodProfiler.new(Petition)

describe MethodProfiler do
  before { @petition = Petition.new }
  after { profiler.reset! }

  it "finds all the object's instance methods" do
    profiler.observed_singleton_methods.sort.should == [:hay, :guys].sort
    profiler.observed_instance_methods.sort.should == [:foo, :bar, :baz].sort
  end

  it "creates wrapper methods for each method in the object" do
    @petition.should respond_to(:foo)
    @petition.should respond_to(:foo_with_profiling)
    @petition.should respond_to(:foo_without_profiling)
    @petition.should_not respond_to(:foo_with_profiling_with_profiling)
  end

  describe "#profile" do
    it "adds a new record for the method call" do
      @petition.foo
      profiler.data["#foo"].size.should == 1
    end

    it "calls the real method" do
      @petition.should_receive(:foo_without_profiling)
      @petition.foo
    end

    it "returns the value of the real method" do
      @petition.class.guys.should == "sup"
      @petition.baz.should == "blah"
    end
  end

  describe "#report" do
    it "returns a new Report object" do
      profiler.report.should be_an_instance_of MethodProfiler::Report
    end
  end
end
