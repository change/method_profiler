require 'hirb'

module Hirb::Helpers::Table::Filters
  def to_milliseconds(seconds)
    "%.3f ms" % (seconds * 1000)
  end
end
