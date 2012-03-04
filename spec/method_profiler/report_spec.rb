require 'spec_helper'

describe MethodProfiler::Report do
  before do
    profiler = MethodProfiler::Profiler.new(Petition)
    petition = Petition.new

    [:hay, :hay, :guys].each { |m| petition.class.send(m) }
    [:foo, :bar, :baz].each { |m| petition.send(m) }

    @report = profiler.report
  end

  describe "#to_s" do
    it "outputs one line for each method that was called" do
      output = @report.to_s

      output.scan(/\.hay/).size.should == 1
      output.scan(/\.guys/).size.should == 1
      output.scan(/#foo/).size.should == 1
      output.scan(/#bar/).size.should == 1
      output.scan(/#baz/).size.should == 1
    end
  end
end
