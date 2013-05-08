module Visualization
  class DealsByMonthChart
    attr_reader :title, :legend

    def initialize(deals, params = {})
      @deals = deals
      @start_date = params[:start_date] || Date.today
      @end_date = params[:end_date] || Date.today + 3.years
      @title = params[:title] || "Deals"
      @legend = params[:legend] || "right"
    end

    def to_a
      [].tap do |array|
        array.push(header_row)
        months.each do |month|
          array.push(month_row(month))
        end
      end
    end

    private

    def months
      @months ||= Month.between(@start_date, @end_date)
    end

    def header_row
      ["Month"].tap do |header|
        @deals.each do |deal|
          header.push deal.name
        end
      end
    end

    def month_row(month)
      [month.to_s].tap do |row|
        @deals.each do |deal|
          row.push(deal_entry(deal, month))
        end
      end
    end

    def deal_entry(deal, month)
      if deal.date_range && month.overlaps_with?(deal.date_range)
        deal.daily_budget || 0
      else
        0
      end
    end
  end
end