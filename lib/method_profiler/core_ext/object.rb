# Backport Object.singleton_class functionality introduced in 1.9.2
class Object
  def singleton_class
    class << self; self end
  end
end if RUBY_VERSION < "1.9.2"