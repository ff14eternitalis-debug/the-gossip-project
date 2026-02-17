class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :edit, :update, :destroy ]
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :authorize_comment!, only: [ :edit, :update, :destroy ]

  def create
    @gossip = Gossip.find(params[:gossip_id])
    @comment = @gossip.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @gossip, notice: "Commentaire ajouté."
    else
      render "gossips/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to gossip_for_comment(@comment), notice: "Commentaire modifié."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    gossip = gossip_for_comment(@comment)
    @comment.destroy
    redirect_to gossip_path(gossip), notice: "Commentaire supprimé."
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_comment!
    return if current_user == @comment.user

    redirect_to gossip_for_comment(@comment), alert: "Vous n'êtes pas autorisé à modifier ce commentaire."
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def gossip_for_comment(comment)
    c = comment.commentable
    c.is_a?(Gossip) ? c : gossip_for_comment(c)
  end
end
