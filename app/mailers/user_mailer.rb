class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: "Bienvenue sur The Gossip Project !")
  end

  def new_comment(comment)
    @comment = comment
    @gossip = comment.commentable
    @recipient = @gossip.user
    return unless @recipient != comment.user

    mail(to: @recipient.email, subject: "Nouveau commentaire sur votre potin")
  end
end
