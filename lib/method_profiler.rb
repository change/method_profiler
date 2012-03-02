require 'benchmark'
require 'hirb'

class MethodProfiler
  attr_reader :observed_methods, :data

  def initialize(obj)
    @obj = obj
    initialize_data
    find_obj_methods
    wrap_methods_with_profiling
  end

  def profile(method, &block)
    result = nil
    benchmark = Benchmark.measure { result = block.call }
    elapsed_time = benchmark.to_s.match(/\(\s*([^\)]+)\)/)[1].to_f
    @data[method.to_sym] << elapsed_time
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

  def find_obj_methods
    @observed_methods ||= begin
      methods = @obj.instance_methods
      @obj.ancestors.each do |a|
        next if a == @obj
        methods -= a.instance_methods
      end
      methods
    end
  end

  def wrap_methods_with_profiling
    profiler = self
    observed = observed_methods

    @obj.module_eval do
      observed.each do |method|
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
