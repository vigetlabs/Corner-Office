require "spec_helper"

describe Highrise::Token do
  let(:client){ double }
  let(:web_server){ double }
  before do
    Highrise::Client.stub(:new){ client }
    client.stub(:web_server){ web_server }
  end

  describe ".authorize_url" do
    before { web_server.stub(:authorize_url){ "authorize_url" } }

    it "returns the authorize url" do
      described_class.authorize_url.should == "authorize_url"
    end
  end

  describe "#initialize" do
    let(:token){ double }
    before { web_server.stub(:get_token){ token } }

    it "returns an instance of HighriseToken" do
      described_class.new("auth_code").should be_a Highrise::Token
    end
  end

  describe "#to_s" do
    let(:token){ double }
    before do
      web_server.stub(:get_token){ token }
      token.stub(:token){ "secret" }
    end

    it "returns the token string" do
      described_class.new("auth_code").to_s.should == "secret"
    end
  end
end