require 'spec_helper'

describe MethodProfiler::Report do
  let!(:profiler) { MethodProfiler::Profiler.new(Petition) }
  let(:petition) { Petition.new }

  it "outputs one line for each method that was called" do
    petition.class.hay
    petition.class.guys
    petition.foo
    petition.bar
    petition.baz

    report = profiler.report.to_s

    report.scan(/.hay/).size.should == 1
    report.scan(/.guys/).size.should == 1
    report.scan(/#foo/).size.should == 1
    report.scan(/#bar/).size.should == 1
    report.scan(/#baz/).size.should == 1
  end

  it "combines multiple calls to the same method into one line" do
    petition.class.hay
    petition.class.hay
    petition.foo
    petition.foo

    report = profiler.report.to_s

    report.scan(/.hay/).size.should == 1
    report.scan(/#foo/).size.should == 1
  end
end
