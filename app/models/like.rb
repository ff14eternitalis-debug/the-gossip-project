class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: [ :likeable_type, :likeable_id ] }

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  after_create_commit :notify_author

  private

  def notify_author
    recipient = likeable.respond_to?(:user) ? likeable.user : nil
    return if recipient.nil? || recipient == user

    Notification.create(user: recipient, notifiable: self, action: "like")
  end
end
