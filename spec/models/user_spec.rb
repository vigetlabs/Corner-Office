require "spec_helper"

describe User do
  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should validate_uniqueness_of(:email) }

    it { should allow_value("test@test.com").for(:email) }
    it { should_not allow_value("test.com").for(:email) }

    it { should_not allow_value("short").for(:password) }
    it { should allow_value("justright").for(:password) }
  end

  describe "associations" do
    it { should have_many(:tokens) }
  end

  describe "#name" do
    let(:user){ create(:user, :first_name => "Marie", :last_name => "Curie") }

    it "returns the combined first and last name" do
      user.name.should == "Marie Curie"
    end
  end

  describe "#token" do
    let(:user){ create(:user) }

    context "when the user has one oauth token" do
      let!(:token){ create(:token, :user => user) }

      it "returns the token" do
        user.token.should == token
      end
    end

    context "when the user has no oauth token" do
      it "returns nil" do
        user.token.should be_nil
      end
    end

    context "when the user has multiple oauth tokens" do
      let!(:token1){ create(:token, :user => user, :created_at => Date.today) }
      let!(:token2){ create(:token, :user => user, :created_at => Date.yesterday) }

      it "returns the most recent token" do
        user.token.should == token1
      end
    end
  end
end
