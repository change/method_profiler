require 'benchmark'

class MethodProfiler
  attr_reader :observed_methods, :data

  def initialize(obj)
    @obj = obj
    @observed_methods = find_obj_methods
    @data = Hash.new { |h, k| h[k] = [] }
    wrap_methods_with_profiling
  end

  def profile(method, &block)
    benchmark = Benchmark.measure { block.call }
    elapsed_time = benchmark.to_s.match(/\(\s*([^\)]+)\)/)[1].to_f
    @data[method.to_sym] << elapsed_time
  end

  def report
    out = []
    out << header
    final_data = calculate_final_data
    final_data.each do |method|
      out << "#{method[0]} #{method[1]} #{method[2]}"
    end
    out << divider
    out.join("\n")
  end

  private

  def find_obj_methods
    methods = @obj.instance_methods
    @obj.ancestors.each do |a|
      next if a == @obj
      methods -= a.instance_methods
    end
    methods
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

  def calculate_final_data
    @final_data ||= begin
      final_data = []
      data.each do |method, records|
        total_calls = records.size
        average = records.reduce(:+) / total_calls
        final_data << [method, average, total_calls]
      end
      final_data.sort! { |a, b| b[1] <=> a[1] }
      final_data
    end
  end

  def header
    ["=========== MethodProfiler data ===========", divider].join("\n")
  end

  def divider
    "==========================================="
  end
end
