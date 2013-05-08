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
end
