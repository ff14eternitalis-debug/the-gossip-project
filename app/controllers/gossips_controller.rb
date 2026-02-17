class GossipsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_gossip, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_gossip!, only: [ :edit, :update, :destroy ]

  def index
    @pagy, @gossips = pagy(
      Gossip.includes(:user, :tags, :comments, :likes).order(created_at: :desc)
    )
  end

  def show
  end

  def new
    @gossip = Gossip.new
    @tags = Tag.order(:title)
  end

  def create
    @gossip = current_user.gossips.build(gossip_params)

    if @gossip.save
      redirect_to @gossip, notice: "Potin créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tags = Tag.order(:title)
  end

  def update
    if @gossip.update(gossip_params)
      redirect_to @gossip, notice: "Potin modifié avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gossip.destroy
    redirect_to gossips_path, notice: "Potin supprimé."
  end

  private

  def set_gossip
    @gossip = Gossip.find(params[:id])
  end

  def authorize_gossip!
    return if current_user == @gossip.user

    redirect_to @gossip, alert: "Vous n'êtes pas autorisé à modifier ce potin."
  end

  def gossip_params
    params.require(:gossip).permit(:title, :content, :image, tag_ids: [])
  end
end
