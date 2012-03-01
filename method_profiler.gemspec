# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = "method_profiler"
  s.version     = "0.0.1"
  s.authors     = ["Jimmy Cuadra"]
  s.email       = ["jimmy@jimmycuadra.com"]
  s.homepage    = "https://github.com/change/method_profiler"
  s.summary     = %q{Find slow methods in your program.}
  s.description = %q{MethodProfiler observes your code and generates reports about the methods that were run and how long they took.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "hirb", ">= 0.6.0"
  s.add_development_dependency "rspec"
end
