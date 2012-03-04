require 'method_profiler/profiler'

# {MethodProfiler} collects performance information about the methods
# in your objects and creates reports to help you identify slow methods.
#
module MethodProfiler
  # Create a new {MethodProfiler::Profiler} which will observe all method calls
  # on the given object. This is a convenience method and has the same effect
  # as {MethodProfiler::Profiler#initialize}.
  #
  # @param [Object] obj The object to observe.
  # @return [MethodProfiler::Profiler] A new profiler.
  #
  def self.observe(obj)
    Profiler.new(obj)
  end
end
