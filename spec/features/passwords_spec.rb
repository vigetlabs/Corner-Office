require "spec_helper"

describe "A user" do
  let(:user) { create(:user) }

  describe "requesting reset instruction delivery" do
    before do
      PasswordResetMailer.deliveries.clear
      visit "/session/new/"
      click_link "Forgot password?"
    end

    context "when providing an existing email address" do
      before { fill_in_password_reset_form_with(user.email) }

      it "is sent an email" do
        PasswordResetMailer.deliveries.should_not be_empty
      end

      it "is redirected to the root path with a success message" do
        current_path.should eql(login_path)
        page.should have_content I18n.t("password.create.success")
      end
    end

    context "when providing a non-existant email address" do
      before { fill_in_password_reset_form_with("non-existant@email.address") }

      it "sees a re-rendered form with errors" do
        current_path.should eql(new_password_path)
        page.should have_content I18n.t("password.create.error")
      end

      it "is not sent an email" do
        PasswordResetMailer.deliveries.should be_empty
      end
    end
  end

  describe "following the reset link" do
    before { request_password_reset_for(user) }

    context "with a valid token" do
      before { visit "/account/password/edit?token=#{user.password_reset_token}" }

      it "sees a reset password form" do
        current_path.should eql(edit_account_password_path)
        page.should have_content "Reset Your Password"
      end
    end

    context "with an invalid token" do
      before { visit "/account/password/edit?token=invalid-token" }

      it "is redirected to the password reset request page" do
        current_path.should eql(new_password_path)
        page.should have_content I18n.t("password.edit.error")
      end
    end
  end

  describe "submitting the reset form" do
    let(:initial_crypt_password) { user.crypted_password }
    before do
      request_password_reset_for(user)
      visit "/account/password/edit/?token=#{user.password_reset_token}"
    end

    context "providing matching password and confirmation" do
      before do
        fill_in "user_password",              :with => "new-password"
        fill_in "user_password_confirmation", :with => "new-password"
        click_button "Save"
      end

      it "sees a success message" do
        page.should have_content I18n.t("user.update.success")
      end

      it "changes their password" do
        click_link "Logout"
        fill_in "Email",    :with => user.email
        fill_in "Password", :with => "new-password"
        click_button "Submit"

        page.should have_content I18n.t("session.create.success")
      end
    end

    context "providing non-matching password and confirmation" do
      before do
        fill_in "user_password",              :with => "new-password"
        fill_in "user_password_confirmation", :with => "different-new-password"
        click_button "Save"
      end

      it "sees the re-rendered edit form with errors" do
        current_path.should eql(account_path)
        page.should have_content I18n.t("user.update.error")
      end
    end
  end

  def fill_in_password_reset_form_with(email)
    fill_in "Email", :with => email
    click_button "Request Reset Instructions"
  end

  def request_password_reset_for(user)
    visit "/password/new/"
    fill_in_password_reset_form_with(user.email)
    user.reload
  end
end
