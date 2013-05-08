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
end
