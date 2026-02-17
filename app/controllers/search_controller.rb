class SearchController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    if @query.present?
      like_query = "%#{@query}%"
      @gossips = Gossip.includes(:user, :tags)
        .where("gossips.title LIKE :q OR gossips.content LIKE :q", q: like_query)
        .order(created_at: :desc)
      @users = User.where("first_name LIKE :q OR last_name LIKE :q OR email LIKE :q", q: like_query)
        .order(:first_name)
      @tags = Tag.where("title LIKE :q", q: like_query).order(:title)
    else
      @gossips = Gossip.none
      @users = User.none
      @tags = Tag.none
    end
  end
end
