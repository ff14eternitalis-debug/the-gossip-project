class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.recent.includes(:notifiable).limit(50)
    current_user.notifications.unread.update_all(read: true)
  end
end
