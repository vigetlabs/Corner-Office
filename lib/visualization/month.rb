module Visualization
  class Month < Range
    def self.between(start_date, end_date)
      [].tap do |months|
        (start_date.year..end_date.year).each do |y|
          (starting_month(start_date, y)..ending_month(end_date, y)).each do |m|
            months << new(y,m)
          end
        end
      end
    end

    def initialize(year, month)
      beginning_of_month = DateTime.new(year, month).beginning_of_day
      end_of_month = beginning_of_month.at_end_of_month.end_of_day
      super(beginning_of_month, end_of_month)
    end

    def overlaps_with?(range)
      self.include?(range.first) ||
      self.include?(range.last)  ||
      range.include?(self.first)
    end

    def to_s
      first.strftime(self.class.string_format)
    end

    private

    def self.starting_month(start_date, year)
      (start_date.year == year) ? start_date.month : 1
    end

    def self.ending_month(end_date, year)
      (end_date.year == year) ? end_date.month : 12
    end

    def self.string_format
      "%m/%Y"
    end
  end
end
