class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true
  validates :age, numericality: { greater_than: 0 }, allow_nil: true

  has_one_attached :avatar

  after_create_commit :send_welcome_email

  belongs_to :city, optional: true
  has_many :gossips
  has_many :comments
  has_many :likes
  has_many :notifications, dependent: :destroy
  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower
  has_many :sent_messages, foreign_key: :sender_id, class_name: "PrivateMessage"
  has_many :private_message_recipients, foreign_key: :recipient_id
  has_many :received_messages, through: :private_message_recipients, source: :private_message

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end
end
