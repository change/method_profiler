require 'spec_helper'

describe MethodProfiler::Report do
  before do
    profiler = MethodProfiler::Profiler.new(Petition)

    # Fake the timings for testing purposes
    profiler.stub(:benchmark) do |block_to_benchmark|
      result = block_to_benchmark.call
      "(#{rand})"
    end

    petition = Petition.new

    [:hay, :guys].each { |m| petition.class.send(m) }
    [:foo, :bar, :baz].each { |m| petition.send(m) }
    [:shh].each { |m| petition.send(m) }

    @report = profiler.report
  end

  describe "#to_a" do
    it "returns an array of records" do
      results = @report.to_a
      results.should be_an Array
      results.size.should == 6
    end

    it "returns results sorted by average time (descending) by default" do
      results = @report.to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort.reverse
    end
  end

  describe "#sort_by" do
    it "sets the result key to order results by" do
      results = @report.sort_by(:min).to_a
      min_times = results.map { |r| r[:min] }
      min_times.should == min_times.sort.reverse
    end

    it "defaults to average if an invalid sort type is passed" do
      results = @report.sort_by(:foo).to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort.reverse
    end
  end

  describe "#order" do
    it "sets the sort direction" do
      results = @report.order(:ascending).to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort
    end

    it "defaults to descending if an invalid direction is passed" do
      results = @report.order(:foo).to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort.reverse
    end

    it "allows :asc and :desc aliases" do
      results = @report.order(:asc).to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort

      results = @report.order(:desc).to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort.reverse
    end
  end

  describe "#to_s" do
    it "outputs one line for each method that was called" do
      output = @report.to_s

      output.should be_a String
      output.scan(/\.hay/).size.should == 1
      output.scan(/\.guys/).size.should == 1
      output.scan(/#foo/).size.should == 1
      output.scan(/#bar/).size.should == 1
      output.scan(/#baz/).size.should == 1
    end
  end
end
