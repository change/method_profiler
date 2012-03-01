# MethodProfiler

**MethodProfiler** collects performance information about the methods in your objects and creates reports to help you identify slow methods.

```ruby
profiler = MethodProfiler.new(MyClass)
MyClass.new.foo
puts profiler.report

# MethodProfiler results for:
# MyClass
# +--------+--------------+-------------+
# | Method | Average Time | Total Calls |
# +--------+--------------+-------------+
# | foo    | 91.037000 ms | 1           |
# | bar    | 15.016000 ms | 2           |
# | baz    | 23.005000 ms | 1           |
# +--------+--------------+-------------+
```
