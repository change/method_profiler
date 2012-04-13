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

    it "sorts by another type if it's been changed" do
      results = @report.sort_by(:min).to_a
      min_times = results.map { |r| r[:min] }
      min_times.should == min_times.sort.reverse
    end

    it "sorts in a different direction if it's been changed" do
      results = @report.order(:ascending).to_a
      average_times = results.map { |r| r[:average] }
      average_times.should == average_times.sort
    end
  end

  describe "#sort_by" do
    it "sets the sort type" do
      @report.sort_by(:total_calls)
      @report.instance_variable_get("@sort_by").should == :total_calls
    end

    it "defaults to average if an invalid sort type is passed" do
      @report.sort_by(:foo)
      @report.instance_variable_get("@sort_by").should == :average
    end
  end

  describe "#order" do
    it "sets the sort direction" do
      @report.order(:ascending)
      @report.instance_variable_get("@order").should == :ascending
    end

    it "defaults to descending if an invalid direction is passed" do
      @report.order(:foo)
      @report.instance_variable_get("@order").should == :descending
    end

    it "allows normalizes :asc and :desc aliases" do
      @report.order(:asc)
      @report.instance_variable_get("@order").should == :ascending

      @report.order(:desc)
      @report.instance_variable_get("@order").should == :descending
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
