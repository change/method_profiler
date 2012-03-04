require 'method_profiler/report'

require 'benchmark'

module MethodProfiler
  class Profiler
    def initialize(obj)
      @obj = obj
      @data = Hash.new { |h, k| h[k] = [] }

      wrap_methods_with_profiling
    end

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
          define_method("#{method}_with_profiling") do |*args|
            profiler.send(:profile, method, true) { send("#{method}_without_profiling", *args) }
          end

          alias_method "#{method}_without_profiling", method
          alias_method method, "#{method}_with_profiling"
        end
      end

      @obj.module_eval do
        instance_methods_to_wrap.each do |method|
          define_method("#{method}_with_profiling") do |*args|
            profiler.send(:profile, method) { send("#{method}_without_profiling", *args) }
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
      benchmark = Benchmark.measure { result = block.call }
      elapsed_time = benchmark.to_s.match(/\(\s*([^\)]+)\)/)[1].to_f
      @data[method_name] << elapsed_time
      result
    end

    def final_data
      results = []

      @data.each do |method, records|
        total_calls = records.size
        average = records.reduce(:+) / total_calls
        results << {
          method: method,
          min: records.min,
          max: records.max,
          average: average,
          total_calls: total_calls
        }
      end

      results
    end
  end
end
