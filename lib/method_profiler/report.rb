require 'hirb'
require 'method_profiler/hirb'

module MethodProfiler
  class Report
    FIELDS = [:method, :min, :max, :average, :total_calls]
    DIRECTIONS = [:asc, :ascending, :desc, :descending]

    def initialize(data)
      @data = data
      @sort_by = :average
      @order = :descending
    end

    def sort_by(field = nil)
      field = :average unless FIELDS.include?(field)

      @sort_by = field
    end

    def order(direction = nil)
      direction = :descending unless DIRECTIONS.include?(direction)
      direction = :descending if direction == :desc
      direction = :ascending if direction == :asc

      @order = direction
    end

    def to_s
      [
        "MethodProfiler results for: #{@obj}",
        Hirb::Helpers::Table.render(
          sorted_data,
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

    private

    def sorted_data
      if @order == :ascending
        @data.sort { |a, b| a[@sort_by] <=> b[@sort_by] }
      else
        @data.sort { |a, b| b[@sort_by] <=> a[@sort_by] }
      end
    end
  end
end
