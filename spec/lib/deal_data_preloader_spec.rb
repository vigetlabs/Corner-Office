require "spec_helper"

describe DealDataPreloader do
  describe "#preload" do
    let(:deal1){ double }
    let(:deal2){ double }
    let(:deals){ [deal1, deal2] }
    let(:deal_data1){ double }
    let(:deal_data2){ double }
    let(:deal_data_array){ [deal_data1, deal_data2] }
    let(:preloader){ described_class.new(deals) }
    before do
      deal1.stub(:id){ 1 }
      deal2.stub(:id){ 42 }
      deal_data1.stub(:deal_id){ 1 }
      deal_data2.stub(:deal_id){ 2 }
      DealData.stub(:find_all_by_deal_id).with([deal1.id, deal2.id]){ deal_data_array }
    end

    it "sends #deal_data= to each deal" do
      deal1.should_receive(:deal_data=).with(deal_data1)
      deal2.should_receive(:deal_data=).with(nil)

      preloader.preload
    end
  end
end