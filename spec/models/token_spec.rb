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
      highrise_token.stub(:to_s){ "token_string" }
    end

    it "sends #create with a token string" do
      described_class.should_receive(:create).with({ :secret => "token_string" })
      described_class.create_from_auth_code("auth_code")
    end

    it "returns an instance of Token" do
      described_class.create_from_auth_code("auth_code").should be_a(Token)
    end

    context "if an oauth error occurs" do
      let(:error_response){ double }
      before do
        error_response.stub(:error=){ nil }
        error_response.stub(:parsed){ nil }
        error_response.stub(:body){ nil }
        Highrise::Token.stub(:new).and_raise(OAuth2::Error.new(error_response))
      end

      it "returns a token with a blank secret" do
        described_class.create_from_auth_code("auth_code").secret.should be_blank
      end
    end
  end
end
