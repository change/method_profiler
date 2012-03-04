require 'method_profiler/report'

require 'benchmark'

module MethodProfiler
  class Profiler
    attr_reader :observed_singleton_methods, :observed_instance_methods, :data

    def initialize(obj)
      @obj = obj
      @observed_singleton_methods = find_object_methods(obj.singleton_class, true)
      @observed_instance_methods = find_object_methods(obj)

      reset!
      wrap_methods_with_profiling
    end

    def profile(method, singleton = false, &block)
      method_name = singleton ? ".#{method}" : "##{method}"
      result = nil
      benchmark = Benchmark.measure { result = block.call }
      elapsed_time = benchmark.to_s.match(/\(\s*([^\)]+)\)/)[1].to_f
      @data[method_name] << elapsed_time
      result
    end

    def report
      Report.new(final_data)
    end

    def reset!
      @data = Hash.new { |h, k| h[k] = [] }
    end

    private

    def find_object_methods(obj, singleton = false)
      obj.instance_methods - obj.ancestors.map do |a|
        if a == obj
          []
        else
          if singleton
            a.singleton_class.instance_methods
          else
            a.instance_methods
          end
        end
      end.flatten
    end

    def wrap_methods_with_profiling
      profiler = self
      osm = observed_singleton_methods
      oim = observed_instance_methods

      @obj.singleton_class.module_eval do
        osm.each do |method|
          define_method("#{method}_with_profiling") do |*args|
            profiler.profile(method, true) { send("#{method}_without_profiling", *args) }
          end

          alias_method "#{method}_without_profiling", method
          alias_method method, "#{method}_with_profiling"
        end
      end

      @obj.module_eval do
        oim.each do |method|
          define_method("#{method}_with_profiling") do |*args|
            profiler.profile(method) { send("#{method}_without_profiling", *args) }
          end

          alias_method "#{method}_without_profiling", method
          alias_method method, "#{method}_with_profiling"
        end
      end
    end

    def final_data(options)
      results = []

      data.each do |method, records|
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
