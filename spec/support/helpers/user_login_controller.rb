module UserLoginController
  def login(user)
    controller.current_user = user
  end
end
