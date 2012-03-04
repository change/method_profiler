require 'spec_helper'

describe MethodProfiler::Report do
  xit "outputs a string of report data" do
    profiler.report.should be_an_instance_of(String)
  end

  xit "outputs one line for each method that was called" do
    @petition.class.hay
    @petition.class.guys
    @petition.foo
    @petition.bar
    @petition.baz
    profiler.report.scan(/.hay/).size.should == 1
    profiler.report.scan(/.guys/).size.should == 1
    profiler.report.scan(/#foo/).size.should == 1
    profiler.report.scan(/#bar/).size.should == 1
    profiler.report.scan(/#baz/).size.should == 1
  end

  xit "combines multiple calls to the same method into one line" do
    @petition.class.hay
    @petition.class.hay
    @petition.foo
    @petition.foo
    profiler.report.scan(/.hay/).size.should == 1
    profiler.report.scan(/#foo/).size.should == 1
  end
end
