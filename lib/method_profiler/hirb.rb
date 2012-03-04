require 'hirb'

# All methods in this module can be used as filters in Hirb.
#
module Hirb::Helpers::Table::Filters
  # Converts seconds to milliseconds. Used to format times in
  # the output of {MethodProfiler::Report}.
  #
  # @param [Float] seconds The duration to convert.
  # @return [String] The duration in milliseconds with units displayed. Rounded to 3 decimal places.
  def to_milliseconds(seconds)
    "%.3f ms" % (seconds * 1000)
  end
end
