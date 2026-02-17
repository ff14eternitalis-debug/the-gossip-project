class LikesController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :destroy ]

  def create
    likeable = find_likeable
    unless likeable
      redirect_back fallback_location: root_path, alert: "Action impossible."
      return
    end
    like = current_user.likes.build(likeable: likeable)
    if like.save
      redirect_back fallback_location: root_path, notice: "Like ajouté."
    else
      redirect_back fallback_location: root_path, alert: "Impossible d'ajouter le like."
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    like.destroy
    redirect_back fallback_location: root_path, notice: "Like retiré."
  end

  private

  def find_likeable
    type = params[:likeable_type]
    id = params[:likeable_id]
    return nil unless %w[Gossip Comment].include?(type)

    type.constantize.find(id)
  end
end
