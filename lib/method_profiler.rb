require 'benchmark'
require 'hirb'

class MethodProfiler
  attr_reader :observed_singleton_methods, :observed_instance_methods, :data

  def initialize(obj)
    @obj = obj
    @observed_singleton_methods = find_object_methods(obj.singleton_class, true)
    @observed_instance_methods = find_object_methods(obj)
    initialize_data
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
    [
      "MethodProfiler results for: #{@obj}",
      Hirb::Helpers::Table.render(
        final_data,
        headers: {
          method: "Method",
          min: "Min Time",
          max: "Max Time",
          average: "Average Time",
          total_calls: "Total Calls"
        },
        fields: [:method, :min, :max, :average, :total_calls],
        description: false
      )
    ].join("\n")
  end

  def reset!
    initialize_data
    @final_data = nil
  end

  private

  def initialize_data
    @data = Hash.new { |h, k| h[k] = [] }
  end

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

  def final_data
    @final_data ||= begin
      final_data = []

      data.each do |method, records|
        total_calls = records.size
        average = records.reduce(:+) / total_calls
        final_data << {
          method: method,
          min: records.min,
          max: records.max,
          average: average,
          total_calls: total_calls
        }
      end

      final_data.sort! { |a, b| b[:average] <=> a[:average] }

      final_data.each do |record|
        [:min, :max, :average].each { |k| record[k] = to_ms(record[k]) }
      end

      final_data
    end
  end

  def to_ms(seconds)
    "%.3f ms" % (seconds * 1000)
  end
end
