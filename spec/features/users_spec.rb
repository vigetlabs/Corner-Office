require "spec_helper"

describe "a visitor" do
  context "on the registration page" do
    before { visit "/account/new" }

    context "that fills in valid user attributes" do
      before do
        fill_in "user_email",      :with => "marie.curie@upmc.fr"
        fill_in "user_first_name", :with => "Marie"
        fill_in "user_last_name",  :with => "Curie"
        fill_in "user_password",   :with => "1s0t0pesRKewl"
        fill_in "user_password_confirmation",   :with => "1s0t0pesRKewl"
        submit_form
      end

      it "is redirected to the edit account page" do
        current_path.should == edit_account_path
        User.find_by_email("marie.curie@upmc.fr").should_not be_nil
      end
    end

    context "that fills in invalid user attributes" do
      before do
        fill_in "user_email", :with => "marie.curie@upmc.fr"
        submit_form
      end

      it "sees the re-rendered form with errors" do
        current_path.should == account_path
      end
    end
  end

  context "visiting a non-existing page" do
    context "because URL is unrecognized" do
      it "sees the 404 page" do
        visit "/foo"
        page.should have_content("The page you were looking for doesn't exist.")
      end
    end
  end

  context "who has an account" do
    let(:user){ create(:user) }

    context "who has not logged in" do
      context "visiting the login page" do
        before { visit "/login" }

        context "that provides valid login credentials" do
          before do
            fill_in "session_email",    :with => user.email
            fill_in "session_password", :with => user.password
            submit_form
          end

          it "is redirected to the edit account page with a success message" do
            current_path.should == edit_account_path
            page.should have_content I18n.t("session.create.success")
          end
        end

        context "that provides invalid login credentials" do
          before { submit_form }

          it "sees the re-rendered form with an error message" do
            current_path.should == session_path
            page.should have_content I18n.t("session.create.error")
          end
        end
      end

      context "visiting the edit account page" do
        before { visit "/account/edit" }

        it "redirects to the login page with a log in required message" do
          current_path.should == login_path
          page.should have_content I18n.t("session.required")
        end
      end
    end

    context "who has logged in" do
      before { login user }

      context "logging out" do
        before { click_link "Logout" }

        it "is redirected to the login page and sees a logout message" do
          current_path.should == login_path
          page.should have_content I18n.t("session.destroy.success")
        end
      end

      context "visiting the login page" do
        before { visit "/login" }

        it "is redirected to the edit account page" do
          current_path.should == edit_account_path
        end
      end

      context "visiting the edit account page" do
        before { visit "/account/edit" }

        context "that fills in valid user attributes" do
          before do
            fill_in "user_email", :with => "new@email.address"
            submit_form
          end

          it "is redirected to the edit account page with a success message" do
            current_path.should == edit_account_path
            page.should have_content I18n.t("user.update.success")
          end
        end

        context "that fills in invalid user attributes" do
          before do
            fill_in "user_email", :with => "invalid@email"
            submit_form
          end

          it "sees the re-rendered edit account form with an error message" do
            current_path.should == account_path
            page.should have_content I18n.t("user.update.error")
          end
        end
      end
    end
  end

  def submit_form
    click_button "Submit"
  end
end