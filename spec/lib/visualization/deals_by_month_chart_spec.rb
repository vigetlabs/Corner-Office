require "spec_helper"

describe Visualization::DealsByMonthChart do
  let(:params){ {
                  :start_date => Date.new(2013,1,1),
                  :end_date   => Date.new(2013,12,1)
              } }

  describe "#to_a" do
    let(:deal1){ double }
    let(:deal2){ double }
    let(:deals){ [deal1, deal2] }
    let(:chart) { described_class.new(deals, params) }

    before do
      deal1.stub(:name){ "Deal 1" }
      deal2.stub(:name){ "Deal 2" }

      deal1.stub(:date_range){ (Date.new(2013,2,1)..Date.new(2013,8,1)) }
      deal2.stub(:date_range){ (Date.new(2013,3,1)..Date.new(2013,11,1)) }

      deal1.stub(:daily_budget){ 42 }
      deal2.stub(:daily_budget){ 100 }
    end

    it "returns the correct array representation" do
      chart.to_a.should == 
      [
        ["Month", "Deal 1", "Deal 2"],
        ["01/2013", 0, 0],
        ["02/2013", 42, 0],
        ["03/2013", 42, 100],
        ["04/2013", 42, 100],
        ["05/2013", 42, 100],
        ["06/2013", 42, 100],
        ["07/2013", 42, 100],
        ["08/2013", 42, 100],
        ["09/2013", 0, 100],
        ["10/2013", 0, 100],
        ["11/2013", 0, 100],
        ["12/2013", 0, 0]
      ]
    end
  end
end