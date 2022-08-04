module AuthorizationHelper

  def admin_filter
    redirect_to root_path unless current_user.admin?
  end

  def subscribed_filter
    redirect_to root_path unless current_user&.subscribed || current_user&.admin?
  end

end
