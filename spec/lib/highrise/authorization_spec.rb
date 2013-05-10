require "spec_helper"

describe Highrise::Authorization do
  describe ".retrieve" do
    context "when authorized" do
      subject do
        VCR.use_cassette "highrise_authorization", :record => :none do
          described_class.retrieve
        end
      end

      it { should be_a(Highrise::Authorization) }

      it "returns the correct information" do
        subject.identity.id.should == "6409544"
      end
    end

    context "when not authorized" do
      subject do
        VCR.use_cassette "highrise_unauthorized", :record => :none do
          described_class.retrieve
        end
      end

      it { should be_nil }
    end
  end

  describe "#highrise_sites" do
    let(:auth) {
      VCR.use_cassette "highrise_authorization", :record => :none do
        described_class.retrieve
      end
    }

    it "returns a hash of authorized Highrise sites" do
      auth.highrise_sites.should == {
        "Viget Labs Sales / Client Contacts" => "https://vigetsales.highrisehq.com"
      }
    end
  end
end