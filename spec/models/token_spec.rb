require 'spec_helper'

describe Token do
  describe "validations" do
    it { should validate_presence_of(:secret) }
    it { should validate_presence_of(:user) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe ".create_from_auth_code" do
    let(:highrise_token){ double }
    before do
      Highrise::Token.stub(:new).with("auth_code"){ highrise_token }
      highrise_token.stub(:secret){ "token_string" }
    end

    it "sends #new with a token string" do
      described_class.should_receive(:new).with({ :secret => "token_string" })
      described_class.create_from_auth_code("auth_code")
    end

    it "returns an instance of Token" do
      described_class.create_from_auth_code("auth_code").should be_a(Token)
    end
  end
end
