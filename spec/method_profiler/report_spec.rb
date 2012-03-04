require 'spec_helper'

describe MethodProfiler::Report do
  before do
    profiler = MethodProfiler::Profiler.new(Petition)
    petition = Petition.new

    [:hay, :hay, :guys].each { |m| petition.class.send(m) }
    [:foo, :bar, :baz].each { |m| petition.send(m) }

    @report = profiler.report
  end

  describe "#to_a" do
    it "returns an array of records" do
      results = @report.to_a
      results.should be_an Array
      results.size.should == 5
    end

    it "sorts by average time (descending) by default" do
      results = @report.to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort.reverse
    end
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
