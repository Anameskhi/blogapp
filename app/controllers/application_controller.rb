class ApplicationController < ActionController::Base
   include Pagy::Backend
   protect_from_forgery with: :exception, prepend: true
   before_action :set_notifications, if: :current_user
   protect_from_forgery with: :exception
   before_action :set_query
   
   def set_query
      @query = Post.ransack(params[:q])
   end

   
   private
   def set_notifications
    notifications = Notification.where(recipient: current_user).newest_first.limit(9)
    @unread = notifications.unread 
    @read = notifications.read
   end
end
