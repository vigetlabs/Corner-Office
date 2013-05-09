require "spec_helper"

describe Visualization::Month do
  describe ".between" do
    let(:start_date){ Date.new(2013,1) }
    let(:end_date){ Date.new(2013,3) }
    subject { described_class.between(start_date, end_date) }

    it { should be_a(Array) }

    it "contains Month instances" do
      subject.first.should be_a(described_class)
    end

    it "returns the correct number of Month instances" do
      subject.count.should == 3
    end

    it "returns the correct starting Month instance" do
      subject.first.first.month.should == 1
    end

    it "returns the correct ending Month instance" do
      subject.last.first.month.should == 3
    end
  end

  describe "#initialize" do
    subject { described_class.new(2013,1) }

    it "returns an instance of Month" do
      subject.should be_a(described_class)
    end

    it "initializes with the correct start date" do
      subject.first.should == DateTime.new(2013,1,1,0,0,0)
    end

    it "initializes with the correct end date" do
      subject.last.should == DateTime.new(2013,1,31,23,59,59)
    end
  end

  describe "#overlaps_with?" do
    let(:month){ described_class.new(2013,1) }
    subject { month.overlaps_with?(range) }

    context "when the tested start date falls within the month" do
      let(:range){ (Date.new(2013,1,15)..Date.new(2013,2,15)) }

      it { should be_true}
    end

    context "when the tested end date falls within the month" do
      let(:range){ (Date.new(2012,12,15)..Date.new(2013,1,15)) }

      it { should be_true}
    end

    context "when the month falls within the tested range" do
      let(:range){ (Date.new(2012,12,15)..Date.new(2013,2,15)) }

      it { should be_true}
    end

    context "when there is no overlap between the ranges" do
      let(:range){ (Date.new(2013,2,15)..Date.new(2013,3,15)) }

      it { should be_false}
    end
  end

  describe "#to_s" do
    let(:month){ described_class.new(2013,1) }

    it "returns the correct string representation" do
      month.to_s.should == "01/2013"
    end
  end
end