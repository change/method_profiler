# MethodProfiler

**MethodProfiler** collects performance information about the methods in your objects and creates reports to help you identify slow methods.

```ruby
profiler = MethodProfiler.new(MyClass)
MyClass.new.foo
puts profiler.report

# +-----------------------+-----------+------------+--------------+-------------+
# | Method                | Min Time  | Max Time   | Average Time | Total Calls |
# +-----------------------+-----------+------------+--------------+-------------+
# | accusamus_est         | 28.656 ms | 297.959 ms | 153.003 ms   | 3           |
# | autem_iste!           | 26.222 ms | 293.007 ms | 149.201 ms   | 3           |
# | distinctio_eos        | 26.103 ms | 292.888 ms | 149.081 ms   | 3           |
# | laborum_fugit         | 15.208 ms | 260.179 ms | 129.839 ms   | 3           |
# | suscipit_architecto   | 10.257 ms | 238.778 ms | 119.360 ms   | 3           |
# | et_fugit              | 2.886 ms  | 13.460 ms  | 6.539 ms     | 3           |
# | porro_rerum           | 0.095 ms  | 101.794 ms | 4.215 ms     | 27          |
# | provident_molestiae   | 0.004 ms  | 100.385 ms | 3.863 ms     | 27          |
# | nisi_inventore        | 0.140 ms  | 14.166 ms  | 1.041 ms     | 53          |
# | quis_temporibus       | 0.006 ms  | 3.284 ms   | 0.701 ms     | 6           |
# | labore_voluptatum     | 0.004 ms  | 10.734 ms  | 0.450 ms     | 106         |
# | quia_est              | 0.004 ms  | 3.752 ms   | 0.246 ms     | 27          |
# | ut_reiciendis         | 0.071 ms  | 1.934 ms   | 0.162 ms     | 27          |
# | sed_at                | 0.066 ms  | 0.175 ms   | 0.080 ms     | 27          |
# | repellendus_suscipit  | 0.051 ms  | 0.122 ms   | 0.064 ms     | 27          |
# | quas_nesciunt         | 0.023 ms  | 0.026 ms   | 0.025 ms     | 3           |
# | iure_quis             | 0.006 ms  | 0.249 ms   | 0.013 ms     | 54          |
# | dicta_ipsam           | 0.004 ms  | 0.064 ms   | 0.012 ms     | 27          |
# | perspiciatis_aut      | 0.006 ms  | 0.007 ms   | 0.006 ms     | 3           |
# | aperiam_laborum       | 0.004 ms  | 0.010 ms   | 0.005 ms     | 53          |
# +-----------------------+-----------+------------+--------------+-------------+
```
