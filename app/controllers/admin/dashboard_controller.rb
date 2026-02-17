module Admin
  class DashboardController < BaseController
    def index
      @users_count = User.count
      @gossips_count = Gossip.count
      @comments_count = Comment.count
      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_gossips = Gossip.includes(:user).order(created_at: :desc).limit(5)
    end
  end
end
