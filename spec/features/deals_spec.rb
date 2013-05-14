require "spec_helper"
describe "a visitor running js", :js => true do
  let(:user){ create(:user) }
  before do
    Token.skip_callback(:create, :after, :set_default_site_for_user)
    create(:token, :user => user, :secret => "access_token")
    Token.set_callback(:create, :after, :set_default_site_for_user)

    VCR.use_cassette "highrise_authorization", :record => :none do
      login user
    end
  end

  context "visiting the deals page" do
    before do
      DealData.create(:deal_id    => 2651749,
                      :start_date => Date.new(2013,1,1),
                      :end_date   => Date.new(2013,3,1))
      VCR.use_cassette "highrise_deals_response", :record => :none do
        visit "/"
      end
    end

    it "sees a deals by month bar chart" do
      page.should have_selector("#deal-visualization svg")
    end

    context "clicking to a deal page" do
      before do
        VCR.use_cassette "highrise_deal_response", :record => :none do
          click_link "7-Up App"
        end
      end

      it "sees a deal timeline bar chart" do
        page.should have_selector("#deal-visualization svg")
      end
    end
  end
end

describe "a visitor" do
  context "who has an account" do
    let(:user){ create(:user, :site => nil) }

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
        before do
          Token.skip_callback(:create, :after, :set_default_site_for_user)
          create(:token, :user => user, :secret => "access_token")
          Token.set_callback(:create, :after, :set_default_site_for_user)
        end

        context "who does not have a Highrise site set" do
          context "visiting the deals page" do
            before do
              VCR.use_cassette "highrise_authorization", :record => :none do
                visit "/"
              end
            end

            it "is redirected to the edit account page with an error message" do
              current_path.should == edit_account_path
              page.should have_content I18n.t("highrise.site.required")
            end
          end
        end

        context "who has a Highrise site set" do
          before { user.update_attributes(:site => "https://vigetdevs.highrisehq.com/") }

          context "visiting the deals page" do
            before do
              DealData.create(:deal_id    => 2651749,
                              :start_date => Date.new(2013,1,1),
                              :end_date   => Date.new(2013,3,1))
              VCR.use_cassette "highrise_deals_response", :record => :none do
                visit "/"
              end
            end

            it "sees a list of deals" do
              page.find(".deals").should have_link  "7-Up App"
            end

            it "sees a list of deals missing data" do
              page.find(".deals-missing-data").should have_link "Refresh Everything Site UX"
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
                    select "2014", :from => "deal_deal_data_end_date_1i"
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
end