class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  after_create_commit :notify_author

  private

  def notify_author
    recipient = commentable.respond_to?(:user) ? commentable.user : nil
    return if recipient.nil? || recipient == user

    Notification.create(user: recipient, notifiable: self, action: "comment")
  end
end
