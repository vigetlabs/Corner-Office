require "spec_helper"

describe Highrise::Client do
  describe "#initialize" do
    before do
      CornerOffice::HIGHRISE_CONFIG.stub(:[]).with("client_id"){ "client_id" }
      CornerOffice::HIGHRISE_CONFIG.stub(:[]).with("client_secret"){ "client_secret" }
      CornerOffice::HIGHRISE_CONFIG.stub(:[]).with("authorize_url"){ "authorize_url" }
      CornerOffice::HIGHRISE_CONFIG.stub(:[]).with("token_url"){ "token_url" }
      CornerOffice::HIGHRISE_CONFIG.stub(:[]).with("site"){ "site" }
    end

    it "creates an object that is a kind of OAuth2 client" do
      described_class.new.should be_a(OAuth2::Client)
    end

    it "creates an instance with the proper client id" do
      described_class.new.id.should == "client_id"
    end

    it "creates an instance with the proper client secret" do
      described_class.new.secret.should == "client_secret"
    end

    it "creates an instance with the proper authorize url" do
      described_class.new.options[:authorize_url].should == "authorize_url"
    end

    it "creates an instance with the proper token url" do
      described_class.new.options[:token_url].should == "token_url"
    end

    it "creates an instance with the proper site" do
      described_class.new.site.should == "site"
    end
  end
end