require "spec_helper"

describe "a logged-in user" do
  let(:user){ create(:user) }
  before { login user }

  context "on the edit account page" do
    before { visit "/account/edit" }

    it "sees an authorize Highrise link" do
      page.should have_link("authorize_highrise", :href => new_token_path)
    end
  end
end
