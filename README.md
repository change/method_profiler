[![endorse](http://api.coderwall.com/jimmycuadra/endorsecount.png)](http://coderwall.com/jimmycuadra)

# MethodProfiler

**MethodProfiler** collects performance information about the methods in your objects and creates reports to help you identify slow methods. The collected data can be sorted in various ways, converted into an array, or pretty printed as a table.

## Basic usage

Create a new profiler by passing the object you want to profile to `MethodProfiler.observe`. All future class and instance methods called on your object will be recorded by the profiler. To see the results of the profiling as a table, simply print out the report returned by `#report` on the profiler object.

```ruby
profiler = MethodProfiler.observe(MyClass)

MyClass.nisi_inventore
MyClass.nisi_inventore

my_obj = MyClass.new

my_obj.accusamus_est
my_obj.accusamus_est
my_obj.accusamus_est

puts profiler.report
```

The resulting chart includes each method, the minimum time it took to run, the maximum time, the average across all calls, and the total number of times it was called. Class methods are prefixed by a `.` and instance methods are prefixed with a `#`.

```
MethodProfiler results for: MyClass
+------------------------+-----------+------------+--------------+-------------+
| Method                 | Min Time  | Max Time   | Average Time | Total Calls |
+------------------------+-----------+------------+--------------+-------------+
| #accusamus_est         | 32.086 ms | 324.140 ms | 160.252 ms   | 3           |
| #autem_iste!           | 29.607 ms | 318.592 ms | 156.221 ms   | 3           |
| #distinctio_eos        | 29.477 ms | 318.471 ms | 156.097 ms   | 3           |
| #laborum_fugit         | 18.388 ms | 291.900 ms | 140.580 ms   | 3           |
| #suscipit_architecto   | 12.036 ms | 272.279 ms | 130.247 ms   | 3           |
| #et_fugit              | 2.794 ms  | 11.658 ms  | 6.185 ms     | 3           |
| #porro_rerum           | 0.097 ms  | 12.096 ms  | 1.031 ms     | 43          |
| #provident_molestiae   | 0.005 ms  | 3.997 ms   | 0.871 ms     | 6           |
| .nisi_inventore        | 0.368 ms  | 1.329 ms   | 0.849 ms     | 2           |
| #quis_temporibus       | 0.104 ms  | 6.696 ms   | 0.713 ms     | 24          |
| #labore_voluptatum     | 0.004 ms  | 8.834 ms   | 0.447 ms     | 86          |
| #quia_est              | 0.004 ms  | 3.667 ms   | 0.327 ms     | 24          |
| #ut_reiciendis         | 0.004 ms  | 2.842 ms   | 0.250 ms     | 24          |
| #sint_quasi            | 0.066 ms  | 1.836 ms   | 0.166 ms     | 24          |
| #sed_at                | 0.067 ms  | 0.119 ms   | 0.078 ms     | 24          |
| #repellendus_suscipit  | 0.054 ms  | 0.128 ms   | 0.067 ms     | 24          |
| #quas_nesciunt         | 0.024 ms  | 0.026 ms   | 0.025 ms     | 3           |
| #iure_quis             | 0.006 ms  | 0.232 ms   | 0.014 ms     | 48          |
| #dicta_ipsam           | 0.005 ms  | 0.068 ms   | 0.013 ms     | 24          |
| #perspiciatis_aut      | 0.006 ms  | 0.006 ms   | 0.006 ms     | 3           |
| #aperiam_laborum       | 0.004 ms  | 0.009 ms   | 0.005 ms     | 34          |
+------------------------+-----------+------------+--------------+-------------+
```

## Reporting

`MethodProfiler::Profiler#report` actually returns a report object which can be used to sort and display the data in various ways. A report has chainable `#sort_by` and `#order` methods to control the sorting of the report when it is ultimately displayed. The report can be turned into an array by calling `#to_a` and the table shown above by calling `#to_s`.

*Example of sorting by the number of total calls, ascending:*

```ruby
puts profiler.report.sort_by(:total_calls).order(:ascending)
```

`#sort_by` accepts a symbol or string with the name of any of the columns in the table: `:method`, `:min`, `:max`, `:average`, or `:total_calls`.

`#order` accepts a symbol or string of `:ascending` or `:descending`. These can also be abbreviated with `:asc` and `:desc`.

## Documentation

The public API is fully documented using [YARD](http://yardoc.org/) and can be viewed on [RubyDoc.info](http://rubydoc.info/).

## Tests

All code is tested with [RSpec](https://github.com/rspec/rspec). To run the specs, clone the repository, install the dependencies with `bundle install`, and then run `rake`.

## Issues

If you have any problems or suggestions for the project, please open a GitHub issue.

## License

MethodProfiler is available under the included MIT license.

## Acknowledgements

Thank you to [Change.org](http://www.change.org/) for sponsoring the project and to my coworker [Alain Bloch](https://github.com/alainbloch) for the inspiration.
