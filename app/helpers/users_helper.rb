module UsersHelper
  # Return an HTML link for a user.
  def user_link(user)
    return ActionController::Base.helpers.link_to user.username, "//stackexchange.com/users/#{user.stack_exchange_account_id}"
  end
end
