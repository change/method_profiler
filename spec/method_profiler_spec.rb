require 'spec_helper'

describe MethodProfiler do
  describe ".observe" do
    it "returns a new Profiler instance" do
      described_class.observe(Petition).should be_an_instance_of described_class::Profiler
    end
  end
end
