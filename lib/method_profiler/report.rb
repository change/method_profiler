require 'hirb'
require 'method_profiler/hirb'

module MethodProfiler
  # Sorts and displays data collected by a {Profiler}.
  #
  class Report
    # Fields that can be passed to {#sort_by}.
    FIELDS = [:method, :min, :max, :average, :total_calls]

    # Directions that can be passed to {#order}.
    DIRECTIONS = [:asc, :ascending, :desc, :descending]

    # Initializes a new {Report}. Used to sort and display data collected by a {Profiler}.
    #
    # @param [Array] data Data collected by a {Profiler}.
    #
    def initialize(data)
      @data = data
      @sort_by = :average
      @order = :descending
    end

    # Sorts the report by the given field. Defaults to `:average`. Chainable with {#order}.
    #
    # @param [Symbol, String] field Any field from {FIELDS} to sort by.
    # @return [Report] The {Report} object, suitable for chaining or display.
    #
    def sort_by(field)
      field = field.to_sym
      field = :average unless FIELDS.include?(field)
      @sort_by = field
      self
    end

    # Changes the direction of the sort. Defaults to `:descending`. Chainable with {#sort_by}.
    #
    # @param [Symbol, String] direction Any direction from {DIRECTIONS} to direct the sort.
    # @return [Report] The {Report} object, suitable for chaining or display.
    #
    def order(direction)
      direction = direction.to_sym
      direction = :descending unless DIRECTIONS.include?(direction)
      direction = :descending if direction == :desc
      direction = :ascending if direction == :asc
      @order = direction
      self
    end

    # Sorts the data by the currently set criteria and returns an array of profiling results.
    #
    # @return [Array] An array of profiling results.
    #
    def to_a
      if @order == :ascending
        @data.sort { |a, b| a[@sort_by] <=> b[@sort_by] }
      else
        @data.sort { |a, b| b[@sort_by] <=> a[@sort_by] }
      end
    end

    # Sorts the data by the currently set criteria and returns a pretty printed table as a string.
    #
    # @return [String] A table of profiling results.
    #
    def to_s
      [
        "MethodProfiler results for: #{@obj}",
        Hirb::Helpers::Table.render(
          to_a,
          headers: {
            method: "Method",
            min: "Min Time",
            max: "Max Time",
            average: "Average Time",
            total_calls: "Total Calls"
          },
          fields: [:method, :min, :max, :average, :total_calls],
          filters: {
            min: :to_milliseconds,
            max: :to_milliseconds,
            average: :to_milliseconds
          },
          description: false
        )
      ].join("\n")
    end
  end
end
