# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  protect_from_forgery with: :exception, prepend: true
  before_action :set_notifications, if: :current_user
  protect_from_forgery with: :exception
  before_action :set_query
  before_action :set_locale
  before_action :set_categories

  def set_query
    @query = Post.ransack(params[:q])
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def locale_from_header
    request.env.fetch('HTTP_ACCEPT_LANGUAGE', '').scan(/[a-z]{2}/).first
  end

  private
  
  def set_categories
    @nav_categories = Category.where(display_in_nav: true).order(:name)
  end

  def set_notifications
    notifications = Notification.where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread
    @read = notifications.read
  end

  def is_admin!
    redirect_to root_path, alert: "You are not authorized to do that." unless current_user&.admin?
  end
end
