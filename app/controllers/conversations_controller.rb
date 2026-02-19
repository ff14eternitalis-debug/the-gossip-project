class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = PrivateMessage
      .where(sender: current_user)
      .or(PrivateMessage.where(id: current_user.received_messages.select(:id)))
      .includes(:sender, :recipients)
      .order(created_at: :desc)
  end

  def show
    @message = PrivateMessage.includes(:sender, :recipients).find(params[:id])
    authorize_conversation!(@message)
  end

  def new
    @message = PrivateMessage.new
    @recipient = User.find_by(id: params[:recipient_id])
    @users = following_or_all_users
  end

  def create
    @message = current_user.sent_messages.build(message_params)

    if @message.save
      redirect_to conversation_path(@message), notice: "Message envoye."
    else
      @users = following_or_all_users
      render :new, status: :unprocessable_entity
    end
  end

  private

  def authorize_conversation!(message)
    return if message.sender == current_user || message.recipients.include?(current_user)

    redirect_to conversations_path, alert: "Vous n'avez pas acces a ce message."
  end

  def message_params
    params.require(:private_message).permit(:content, recipient_ids: [])
  end

  def following_or_all_users
    friends = current_user.following.order(:first_name)
    friends.any? ? friends : User.where.not(id: current_user.id).order(:first_name)
  end
end
