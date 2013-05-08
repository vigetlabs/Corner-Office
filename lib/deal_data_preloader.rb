class DealDataPreloader
  def initialize(deals)
    @deals = deals
  end

  def preload
    if @deals.is_a?(Array)
      @deals.each do |deal|
        deal.deal_data = indexed_deal_data_records[deal.id]
      end
    end
  end

  private

  def deal_ids
    @deals.map { |deal| deal.id }
  end

  def deal_data_records
    @deal_data_records ||= DealData.find_all_by_deal_id(deal_ids)
  end

  def indexed_deal_data_records
    @indexed_deal_data_records ||= deal_data_records.inject({}) do |hash, record|
      hash[record.deal_id] = record
      hash
    end
  end
end