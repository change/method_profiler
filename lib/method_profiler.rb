class MethodProfiler
  attr_reader :observed_methods, :data

  def initialize(obj)
    @obj = obj
    @observed_methods = find_obj_methods
    @data = Hash.new { |h, k| h[k] = [] }
    wrap_methods_with_profiling
  end

  def profile(method)
    start = Time.now
    yield
    stop = Time.now
    @data[method.to_sym] << { start: start, stop: stop }
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
end
