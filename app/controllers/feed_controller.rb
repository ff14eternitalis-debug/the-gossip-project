class FeedController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!

  def index
    followed_ids = current_user.following.pluck(:id)
    @pagy, @gossips = pagy(
      Gossip.where(user_id: followed_ids).includes(:user, :tags, :comments, :likes).order(created_at: :desc)
    )
  end
end
