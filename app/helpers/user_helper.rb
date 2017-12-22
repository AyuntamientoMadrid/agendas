module UserHelper
  def user_by_role(user)
    return User.model_name.human if user.admin? || user.user?
    "Lobby"
  end
end
