require 'spec_helper'

describe MethodProfiler::Profiler do
  let!(:profiler) { described_class.new(Petition) }
  let(:petition) { Petition.new }

  it "creates wrapper methods for the object's methods" do
    petition.should respond_to(:foo)
    petition.should respond_to(:foo_with_profiling)
    petition.should respond_to(:foo_without_profiling)
    petition.should_not respond_to(:foo_with_profiling_with_profiling)
    petition.private_methods.should include(:shh_with_profiling)
    petition.private_methods.should include(:shh_without_profiling)
  end

  it "returns correct values for class methods" do
    Petition.guys.should == "sup"
  end

  it "returns correct values for instance methods" do
    petition.baz.should == "blah"
  end

  it "returns correct values for private methods" do
    petition.send(:shh).should == "secret"
  end

  it "yields to implicit blocks" do
    petition.method_with_implicit_block {|v| v }.should == "implicit"
  end

  it "calls explicit blocks" do
    petition.method_with_explicit_block {|v| v }.should == "explicit"
  end

  it "yields to implicit blocks with arguments" do
    petition.method_with_implicit_block_and_args(1,2,3) {|v| v }.should == [1,2,3]
  end

  it "calls explicit blocks with arguments" do
    petition.method_with_explicit_block_and_args(1,2,3) {|v| v }.should == [1,2,3]
  end

  describe "#report" do
    it "returns a new Report object" do
      profiler.report.should be_an_instance_of MethodProfiler::Report
    end
  end
end
