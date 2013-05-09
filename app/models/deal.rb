class Deal < Highrise::Deal
  include ReadOnlyResource

  def self.with_preloaded_deal_data(deals)
    deals.tap do |deals|
      DealDataPreloader.new(deals).preload
    end
  end

  def self.filter(filter, deals)
    filter_method = "#{filter}_filter"
    send(filter_method, deals) if respond_to?(filter_method)
  end

  def deal_data=(deal_data)
    @deal_data = deal_data || DealData.new(:deal_id => self.id)
  end

  def deal_data
    @deal_data ||= find_or_build_deal_data
  end

  def update_deal_data(attributes)
    deal_data.update_attributes(attributes.fetch("deal_data", {}))
  end

  def daily_budget
    deal_data.daily_budget(price || 0)
  end

  delegate :start_date, :end_date, :date_range, :probability, :average_rate,
    :to => :deal_data, :allow_nil => true

  private

  def self.missing_data_filter(deals)
    [].tap do |deals_missing_data|
      deals.each do |deal|
        unless deal.start_date && deal.end_date && deal.price
          deals_missing_data.push(deal)
        end
      end
    end
  end

  def find_or_build_deal_data
    DealData.where(:deal_id => self.id).first_or_initialize
  end
end
