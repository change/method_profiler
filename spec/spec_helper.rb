$:.unshift(File.expand_path("../../lib", __FILE__))
require "method_profiler"

class Petition
  def self.hay; end
  def self.guys; "sup"; end
  def foo; end
  def bar; end
  def baz; "blah"; end
end
