require 'spec_helper'

describe DealData do
  describe "validations" do
    it {should validate_presence_of(:deal_id) }
    it {should validate_uniqueness_of(:deal_id) }
    it {should validate_numericality_of(:probability) }
    it {should validate_numericality_of(:average_rate) }

    it { should allow_value(100).for(:probability) }
    it { should allow_value(0).for(:probability) }
    it { should allow_value(50).for(:probability) }
    it { should_not allow_value(-10).for(:probability) }
    it { should_not allow_value(110).for(:probability) }
  end

  describe "#validate_start_date_before_end_date" do
    context "when the start date is before the end date" do
      before do
        subject.stub(:start_date){ Date.yesterday }
        subject.stub(:end_date){ Date.tomorrow }
      end

      it "does not add an error" do
        subject.send :validate_start_date_before_end_date
        subject.errors[:end_date].should_not be_present
      end
    end

    context "when the start date is after the end date" do
      before do
        subject.stub(:start_date){ Date.tomorrow }
        subject.stub(:end_date){ Date.yesterday }
      end

      it "adds an error" do
        subject.send :validate_start_date_before_end_date
        subject.errors[:end_date].should be_present
      end
    end

    context "when the start date is the end date" do
      before do
        subject.stub(:start_date){ Date.current }
        subject.stub(:end_date){ Date.current }
      end

      it "adds an error" do
        subject.send :validate_start_date_before_end_date
        subject.errors[:end_date].should be_present
      end
    end
  end

  describe "#date_range" do
    let(:deal_data){ described_class.new }

    context "if start and end dates are present" do
      before do
        deal_data.start_date = 1
        deal_data.end_date = 2
      end

      it "returns a range of the date values" do
        deal_data.date_range.should == (1..2)
      end
    end

    context "if a date is missing" do
      it "returns nil" do
        deal_data.date_range.should be_nil
      end
    end
  end

  describe "#daily_budget" do
    let(:start_date){ Date.today - 1.day }
    let(:end_date){ Date.today + 1.day }
    let(:deal_data){ described_class.new(:start_date => start_date, :end_date => end_date) }

    it "returns the price divided by the number of days between start and end dates" do
      deal_data.daily_budget(200).should == 100
    end

    context "if a date is missing" do
      before { deal_data.start_date = nil }

      it "returns 0" do
        deal_data.daily_budget(200).should == 0
      end
    end

    context "if there are zero days between the start and end dates" do
      before do
        deal_data.start_date = Date.today
        deal_data.end_date = Date.today
      end

      it "returns 0" do
        deal_data.daily_budget(200).should == 0
      end
    end
  end
end
