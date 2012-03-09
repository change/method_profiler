require 'spec_helper'

describe MethodProfiler::Profiler do
  let!(:profiler) { described_class.new(Petition) }
  let(:petition) { Petition.new }

  it "creates wrapper methods for the object's methods" do
    petition.should respond_to(:foo)
    petition.should respond_to(:foo_with_profiling)
    petition.should respond_to(:foo_without_profiling)
    petition.should_not respond_to(:foo_with_profiling_with_profiling)
  end

  it "class methods should properly return values" do
    Petition.guys.should == "sup"
  end

  it "instance method should properly return values" do
    petition.baz.should == "blah"
  end

  it "method_with_implicit_block" do
    petition.method_with_implicit_block {|v| v }.should == "implicit"
  end

  it "method_with_explicit_block" do
    petition.method_with_explicit_block {|v| v }.should == "explicit"
  end

  it "method_with_implicit_block_and_args" do
    petition.method_with_implicit_block_and_args(1,2,3) {|v| v }.should == [1,2,3]
  end

  it "method_with_explicit_block_and_args" do
    petition.method_with_explicit_block_and_args(1,2,3) {|v| v }.should == [1,2,3]
  end

  describe "#report" do
    it "returns a new Report object" do
      profiler.report.should be_an_instance_of MethodProfiler::Report
    end
  end
end
