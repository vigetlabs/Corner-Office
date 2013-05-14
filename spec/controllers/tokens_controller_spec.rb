require "spec_helper"

describe TokensController do
  describe "#new" do
    context "without an active session" do
      before { get :new }

      it "redirects to the login page" do
        response.should redirect_to login_path
      end
    end

    context "with an active session" do
      let(:user){ create(:user) }
      before do
        login user
        get :new
      end

      it "redirects to a 37Signals authorization page" do
        response.should redirect_to('https://launchpad.37signals.com/authorization/new?type=web_server&client_id=client_id&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauthorize')
      end
    end
  end

  describe "#create" do
    context "without an active session" do
      before { get :create }

      it "redirects to the login page" do
        response.should redirect_to login_path
      end
    end

    context "with an active session" do
      let(:user){ create(:user, :site => nil) }
      before do
        VCR.use_cassette "highrise_authorization", :record => :none do
          login user
        end
      end

      context "including a valid authorization code" do
        let(:valid_auth_code){ "valid_auth_code" }

        it "creates a token" do
          VCR.use_cassette "highrise_token_response_with_valid_auth_code", :record => :none do
            expect{ get :create, :code => valid_auth_code }.to change{ Token.count }.by(1)
          end
        end

        it "redirects to the edit account page" do
          VCR.use_cassette "highrise_token_response_with_valid_auth_code", :record => :none do
            get :create, :code => valid_auth_code
          end

          response.should redirect_to edit_account_path
        end

        it "sets a default site for the highrise user" do
          VCR.use_cassette "highrise_token_response_with_valid_auth_code", :record => :none do
            get :create, :code => valid_auth_code
          end

          user.reload.site.should == "https://vigetsales.highrisehq.com"
        end
      end

      context "including an invalid authorization code" do
        let(:invalid_auth_code){ "invalid_auth_code" }

        it "does not create a token" do
          VCR.use_cassette "highrise_token_response_with_invalid_auth_code", :record => :none do
            expect{ get :create, :code => invalid_auth_code }.to_not change{ Token.count }
          end
        end

        it "redirects to the edit account page" do
          VCR.use_cassette "highrise_token_response_with_invalid_auth_code", :record => :none do
            get :create
          end

          response.should redirect_to edit_account_path
        end

        it "does not set a default site for the user" do
          VCR.use_cassette "highrise_token_response_with_invalid_auth_code", :record => :none do
            get :create, :code => invalid_auth_code
          end

          user.site.should be_nil
        end
      end

      context "not including an authorization code" do
        it "does not create a token" do
          expect{ get :create }.to_not change{ Token.count }
        end

        it "redirects to the edit account page" do
          get :create
          response.should redirect_to edit_account_path
        end
      end
    end
  end
end
