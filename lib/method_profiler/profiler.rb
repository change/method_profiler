require 'method_profiler/report'
require 'method_profiler/core_ext/object'

require 'benchmark'

module MethodProfiler
  # Observes an object, keeping track of all its method calls and the wall clock
  # time spent executing them.
  #
  class Profiler
    # Initializes a new {Profiler}. Wraps all methods in the object and its singleton
    # class with profiling code.
    #
    # @param [Object] obj The object to observe.
    #
    def initialize(obj)
      @obj = obj
      @data = Hash.new { |h, k| h[k] = [] }

      wrap_methods_with_profiling
    end

    # Generates a report object with all the data collected so far bay the profiler. This report
    # can be displayed in various ways. See {Report}.
    #
    # @return [Report] A new report with all the data the profiler has collected.
    #
    def report
      Report.new(final_data)
    end

    private

    def wrap_methods_with_profiling
      profiler = self
      singleton_methods_to_wrap = find_singleton_methods
      instance_methods_to_wrap = find_instance_methods

      @obj.singleton_class.module_eval do
        singleton_methods_to_wrap.each do |method|
          define_method("#{method}_with_profiling") do |*args, &block|
            profiler.send(:profile, method, true) { send("#{method}_without_profiling", *args, &block) }
          end

          alias_method "#{method}_without_profiling", method
          alias_method method, "#{method}_with_profiling"
        end
      end

      @obj.module_eval do
        instance_methods_to_wrap.each do |method|
          define_method("#{method}_with_profiling") do |*args, &block|
            profiler.send(:profile, method) { send("#{method}_without_profiling", *args, &block) }
          end

          alias_method "#{method}_without_profiling", method
          alias_method method, "#{method}_with_profiling"
        end
      end
    end

    def find_singleton_methods
      @obj.singleton_class.instance_methods - @obj.singleton_class.ancestors.map do |a|
        a == @obj ? [] : a.instance_methods
      end.flatten
    end

    def find_instance_methods
      @obj.instance_methods - @obj.ancestors.map do |a|
        a == @obj ? [] : a.instance_methods
      end.flatten
    end

    def profile(method, singleton = false, &block)
      method_name = singleton ? ".#{method}" : "##{method}"
      result = nil
      elapsed_time, result = benchmark(result, &block)
      elapsed_time = elapsed_time.to_s.match(/\(\s*([^\)]+)\)/)[1].to_f
      @data[method_name] << elapsed_time
      result
    end

    def final_data
      results = []

      @data.each do |method, records|
        total_calls = records.size
        total_time = records.reduce(:+)
        average = total_time / total_calls
        results << {
          :method => method,
          :min => records.min,
          :max => records.max,
          :average => average,
          :total_calls => total_calls,
          :total_time => total_time
        }
      end

      results
    end

    private

    def benchmark(result, &block)
      elapsed_time = Benchmark.measure { result = block.call }
      return elapsed_time, result
    end
  end
end
