class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :not_self_follow

  after_create_commit :notify_followed

  private

  def not_self_follow
    errors.add(:follower_id, "ne peut pas se suivre soi-meme") if follower_id == followed_id
  end

  def notify_followed
    Notification.create(user: followed, notifiable: self, action: "follow")
  end
end
