class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @gossips = @tag.gossips.order(created_at: :desc)
  end
end
