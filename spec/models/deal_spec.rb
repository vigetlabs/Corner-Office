require 'spec_helper'

describe Deal do
  describe "ReadOnlyResource module" do
    describe "class methods" do
      let(:class_methods){ [:create] }

      it "raises a read-only exception" do
        class_methods.each do |method|
          expect_read_only_error { described_class.send(method) }
        end
      end
    end

    describe "instance methods" do
      let(:deal){ described_class.new }
      let(:instance_methods){
        [
          :save,
          :save!,
          :update,
          :update_attributes,
          :update_attribute,
          :delete,
          :destroy
        ]
      }

      it "raises a read-only exception" do
        instance_methods.each do |method|
          expect_read_only_error { deal.send(method) }
        end
      end
    end

    describe "#raise_error" do
      let(:deal){ described_class.new }

      it "sends .raise_error to its class" do
        described_class.should_receive(:raise_error)
        deal.raise_error
      end
    end

    describe ".raise_error" do
      it "raises a ReadOnlyError" do
        expect_read_only_error {described_class.raise_error }
      end
    end

    def expect_read_only_error
      lambda{ yield }.should raise_error(ReadOnlyResource::ReadOnlyError)
    end
  end

  describe "#deal_data" do
    let(:deal){ described_class.new }
    before { deal.stub(:id){ 123 } }

    context "if deal_data exists for the deal" do
      let!(:deal_data){ DealData.create(:deal_id => 123) }

      it "returns the persisted DealData" do
        deal.deal_data.should == deal_data
      end
    end

    context "if no DealData exists for the deal" do
      it "returns a DealData" do
        deal.deal_data.should be_a(DealData)
      end

      it "returns an unpersisted object" do
        deal.deal_data.persisted?.should be_false
      end
    end
  end

  describe "#update_deal_data" do
    let(:deal){ described_class.new }
    let(:deal_data){ double }
    before do
      DealData.stub(:find){ deal_data }
      DealData.stub(:new){ deal_data }
    end

    context "with deal_data attrs present" do
      let(:update_attrs){ { "deal_data" => { :probability => 50 } } }

      it "sends update_attributes to DealData with the deal_data attrs" do
        deal_data.should_receive(:update_attributes).with({ :probability => 50 })
        deal.update_deal_data(update_attrs)
      end
    end

    context "without deal_data attrs present" do
      let(:update_attrs){ {} }

      it "sends update_attributes to DealData with an empty hash" do
        deal_data.should_receive(:update_attributes).with({})
        deal.update_deal_data(update_attrs)
      end
    end
  end

  describe "#deal_data=" do
    let(:deal){ described_class.new(:id => 1) }

    context "passed a non-nil value for deal_data" do
      it "sets @deal_data" do
        deal.deal_data = :test
        deal.instance_variable_get(:@deal_data).should == :test
      end
    end

    context "passed a nil value deal_data" do
      let(:deal_data_double){ double }
      before { DealData.stub(:new).with({ :deal_id => 1 }){ deal_data_double } }

      it "sets @deal_data equal to a new DealData instance" do
        deal.deal_data = nil
        deal.instance_variable_get(:@deal_data).should == deal_data_double
      end
    end
  end

  describe "#daily_budget" do
    let(:deal){ described_class.new(:price => 42) }
    let(:deal_data_double){ double }
    before { DealData.stub(:new){ deal_data_double } }

    it "sends #daily_budget to an instance of DealData with the deal price" do
      deal_data_double.should_receive(:daily_budget).with(42)
      deal.daily_budget
    end
  end

  describe ".with_preloaded_deal_data" do
    let(:deal_data_preloader){ double }
    before do
      Highrise::Deal.stub(:with_preloaded_deal_data){ "super_result" }
      DealDataPreloader.stub(:new){ deal_data_preloader }
      deal_data_preloader.stub(:preload){ true }
    end

    it "returns the passed array" do
      described_class.with_preloaded_deal_data([1,2,3]).should == [1,2,3]
    end

    it "initializes a DealDataPreloader" do
      DealDataPreloader.should_receive(:new).with(:deals){ deal_data_preloader }

      described_class.with_preloaded_deal_data(:deals)
    end

    it "sends #preload to a DealDataPreloader instance" do
      DealDataPreloader.stub(:new){ deal_data_preloader }
      deal_data_preloader.should_receive(:preload)

      described_class.with_preloaded_deal_data(:deals)
    end
  end

  describe ".filter" do
    it "sends a message to the filter method" do
      described_class.should_receive(:testing_filter).with(:test_data)
      described_class.filter(:testing, :test_data)
    end
  end

  describe ".missing_data_filter" do
    let(:deal_with_all_data){ described_class.new(:id => 1, :price => 42) }
    let(:deal_missing_date){ described_class.new(:id => 2, :price => 42) }
    let(:deal_missing_price){ described_class.new(:id => 2, :price => nil) }

    let(:deal_data_double1){ double }
    let(:deal_data_double2){ double }
    let(:deal_data_double3){ double }

    before do
      deal_with_all_data.stub(:deal_data){ deal_data_double1 }
      deal_data_double1.stub(:start_date){ Date.today - 1.day }
      deal_data_double1.stub(:end_date){ Date.today + 1.day }

      deal_missing_date.stub(:deal_data){ deal_data_double2 }
      deal_data_double2.stub(:start_date){ nil }
      deal_data_double2.stub(:end_date){ Date.today + 1.day }

      deal_missing_price.stub(:deal_data){ deal_data_double3 }
      deal_data_double3.stub(:start_date){ Date.today - 1.day }
      deal_data_double3.stub(:end_date){ Date.today + 1.day }
    end

    it "returns deals with missing dates and prices" do
      deals_missing_data = described_class.send(:missing_data_filter,
        [deal_with_all_data, deal_missing_date, deal_missing_price])

      deals_missing_data.should == [deal_missing_date, deal_missing_price]
    end
  end
end
