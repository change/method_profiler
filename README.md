[![Build Status](https://secure.travis-ci.org/change/method_profiler.png)](http://travis-ci.org/change/method_profiler) [![Code Climate](https://codeclimate.com/github/change/method_profiler.png)](https://codeclimate.com/github/change/method_profiler) [![endorse](http://api.coderwall.com/jimmycuadra/endorsecount.png)](http://coderwall.com/jimmycuadra)

# MethodProfiler

**MethodProfiler** collects performance information about the methods in your objects and creates reports to help you identify slow methods. The collected data can be sorted in various ways, converted into an array, or pretty printed as a table.

## Basic usage

Create a new profiler by passing the object you want to profile to `MethodProfiler.observe`. All future class and instance methods called on your object will be recorded by the profiler. To see the results of the profiling as a table, simply print out the report returned by `#report` on the profiler object.

```ruby
profiler = MethodProfiler.observe(MyClass)

MyClass.labore_voluptatum
MyClass.labore_voluptatum

my_obj = MyClass.new

my_obj.accusamus_est
my_obj.accusamus_est
my_obj.accusamus_est

puts profiler.report
```

The resulting chart includes each method, the minimum time it took to run, the maximum time, the average across all calls, and the total number of times it was called. Class methods are prefixed by a `.` and instance methods are prefixed with a `#`.

```
MethodProfiler results for: MyClass
+-----------------------+-----------+------------+--------------+------------+-------------+
| Method                | Min Time  | Max Time   | Average Time | Total Time | Total Calls |
+-----------------------+-----------+------------+--------------+------------+-------------+
| #accusamus_est        | 28.722 ms | 393.649 ms | 150.543 ms   | 451.628 ms | 3           |
| #autem_iste!          | 26.220 ms | 387.026 ms | 146.644 ms   | 439.933 ms | 3           |
| #distinctio_eos       | 26.095 ms | 386.903 ms | 146.520 ms   | 439.559 ms | 3           |
| #laborum_fugit        | 14.887 ms | 351.369 ms | 127.564 ms   | 382.692 ms | 3           |
| #suscipit_architecto  | 9.876 ms  | 269.339 ms | 96.440 ms    | 289.319 ms | 3           |
| #et_fugit             | 0.005 ms  | 63.101 ms  | 10.704 ms    | 64.225 ms  | 6           |
| #porro_rerum          | 2.970 ms  | 15.137 ms  | 7.126 ms     | 21.378 ms  | 3           |
| #provident_molestiae  | 0.097 ms  | 17.860 ms  | 1.134 ms     | 27.225 ms  | 24          |
| #nisi_inventore       | 0.098 ms  | 15.076 ms  | 1.044 ms     | 54.272 ms  | 52          |
| #quis_temporibus      | 0.004 ms  | 11.908 ms  | 0.643 ms     | 15.430 ms  | 24          |
| .labore_voluptatum    | 0.440 ms  | 0.470 ms   | 0.455 ms     | 0.910 ms   | 2           |
| #quia_est             | 0.004 ms  | 11.133 ms  | 0.453 ms     | 47.092 ms  | 104         |
| #ut_reiciendis        | 0.004 ms  | 5.626 ms   | 0.346 ms     | 8.302 ms   | 24          |
| #sint_quasi           | 0.062 ms  | 2.152 ms   | 0.188 ms     | 4.504 ms   | 24          |
| #sed_at               | 0.065 ms  | 0.150 ms   | 0.085 ms     | 2.034 ms   | 24          |
| #repellendus_suscipit | 0.051 ms  | 0.122 ms   | 0.070 ms     | 1.684 ms   | 24          |
| .quas_nesciunt        | 0.058 ms  | 0.124 ms   | 0.062 ms     | 4.303 ms   | 69          |
| #iure_quis            | 0.021 ms  | 0.025 ms   | 0.023 ms     | 0.069 ms   | 3           |
| #dicta_ipsam          | 0.006 ms  | 0.266 ms   | 0.017 ms     | 0.798 ms   | 48          |
| #perspiciatis_aut     | 0.004 ms  | 0.068 ms   | 0.013 ms     | 0.314 ms   | 24          |
| .aperiam_laborum      | 0.005 ms  | 0.015 ms   | 0.006 ms     | 0.438 ms   | 69          |
| #voluptas_ratione     | 0.005 ms  | 0.007 ms   | 0.006 ms     | 0.018 ms   | 3           |
| #ex_voluptas          | 0.004 ms  | 0.010 ms   | 0.005 ms     | 0.212 ms   | 41          |
+-----------------------+-----------+------------+--------------+------------+-------------+
```

## Reporting

`MethodProfiler::Profiler#report` actually returns a report object which can be used to sort and display the data in various ways. A report has chainable `#sort_by` and `#order` methods to control the sorting of the report when it is ultimately displayed. The report can be turned into an array by calling `#to_a` and the table shown above by calling `#to_s`.

*Example of sorting by the number of total calls, ascending:*

```ruby
puts profiler.report.sort_by(:total_calls).order(:ascending)
```

`#sort_by` accepts a symbol or string with the name of any of the columns in the table: `:method`, `:min`, `:max`, `:average`, `:total_time`, or `:total_calls`.

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
