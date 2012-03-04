require 'method_profiler/profiler'

module MethodProfiler
  extend self

  def observe(obj)
    Profiler.new(obj)
  end
end
