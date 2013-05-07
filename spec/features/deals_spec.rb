require "spec_helper"

describe "a visitor" do
  context "who has an account" do
    let(:user){ create(:user) }

    context "who has not logged in" do
      context "visiting the deals page" do
        before { visit "/" }

        it "is redirected to the login page with an error message" do
            current_path.should == login_path
            page.should have_content I18n.t("session.required")
        end
      end
    end

    context "who has logged in" do
      before { login user }

      context "who does not have an oauth token" do
        context "visiting the deals page" do
          before { visit "/" }

          it "is redirected to the edit account page with an error message" do
            current_path.should == edit_account_path
            page.should have_content I18n.t("token.required")
          end
        end
      end

      context "who has an oauth token" do
        before { create(:token, :user => user, :secret => "access_token") }

        context "visiting the deals page" do
          before do
            VCR.use_cassette "highrise_deals_response", :record => :none do
              visit "/"
            end
          end

          it "sees her deals" do
            page.should have_link "7-Up App"
          end

          context "clicking on a deal link" do
            before do
              VCR.use_cassette "highrise_deal_response", :record => :none do
                click_link "7-Up App"
              end
            end

            it "sees deal information" do
              page.should have_content "Budget: $1,500,00"
            end

            context "editing deal metadata" do
              before do
                VCR.use_cassette "highrise_deal_response", :record => :none do
                  click_link "Edit"
                end
              end

              context "with valid deal_data attributes" do
                before do
                  fill_in "deal_deal_data_probability", :with => 100
                  VCR.use_cassette "highrise_deal_response", :record => :none,
                    :allow_playback_repeats => true do
                      click_button "Update Deal"
                  end
                end

                it "is redirected to the deal info page with success message" do
                  current_path.should == deal_path(2651749)
                  page.should have_content I18n.t("deal.update.success")
                end

                it "sees the updated deal metadata" do
                  page.should have_content "Win Probability: 100%"
                end
              end

              context "with invalid deal_data attributes" do
                before do
                  fill_in "deal_deal_data_probability", :with => 150
                  VCR.use_cassette "highrise_deal_response", :record => :none,
                    :allow_playback_repeats => true do
                      click_button "Update Deal"
                  end
                end

                it "sees the rerendered deal_data form with an error message" do
                  current_path.should == deal_path(2651749)
                  page.should have_content I18n.t("deal.update.error")
                end
              end
            end
          end
        end
      end
    end
  end
end