# Backports Object#singleton_class from Ruby 1.9.2
class Object
  # Returns the singleton class of an object.
  #
  # @return [Object] The object's singleton class.
  def singleton_class
    class << self; self end
  end
end if RUBY_VERSION < "1.9.2"
