module UserLoginFeature
  def login(user)
    visit "/login"
    fill_in "session_email",    :with => user.email
    fill_in "session_password", :with => user.password
    click_button "Submit"
  end
end

