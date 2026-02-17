class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true
  validates :age, numericality: { greater_than: 0 }, allow_nil: true

  belongs_to :city, optional: true
  has_many :gossips
  has_many :comments
  has_many :likes
  has_many :sent_messages, foreign_key: :sender_id, class_name: "PrivateMessage"
  has_many :private_message_recipients, foreign_key: :recipient_id
  has_many :received_messages, through: :private_message_recipients, source: :private_message
end
