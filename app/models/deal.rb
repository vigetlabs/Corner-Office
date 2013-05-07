class Deal < Highrise::Deal
  include ReadOnlyResource

  def deal_data
    @deal_data ||= find_or_build_deal_data
  end

  def update_deal_data(attributes)
    deal_data.update_attributes(attributes.fetch("deal_data", {}))
  end

  delegate :start_date, :end_date, :probability, :average_rate,
    :to => :deal_data, :allow_nil => true

  private

  def find_or_build_deal_data
    DealData.find(:first, :conditions => { :deal_id => self.id }) ||
      DealData.new(:deal_id => self.id)
  end
end
