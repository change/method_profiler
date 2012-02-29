# MethodProfiler

**MethodProfiler** collects performance information about the methods in your objects and creates reports to help you identify slow methods.

```ruby
profiler = MethodProfiler.new(MyClass)
MyClass.new.my_method
puts profiler.report

# =========== MethodProfiler data ===========
# Method          Average Time    Total Calls
# ===========================================
# my_method       239 ms          1
# foo              84 ms          4
# bar              14 ms          3
# ===========================================
```
