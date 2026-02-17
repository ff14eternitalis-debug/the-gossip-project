class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    current_user.active_follows.create(followed: user)
    redirect_back fallback_location: user_path(user), notice: "Vous suivez #{user.first_name}."
  end

  def destroy
    follow = current_user.active_follows.find(params[:id])
    follow.destroy
    redirect_back fallback_location: root_path, notice: "Vous ne suivez plus cet utilisateur."
  end
end
