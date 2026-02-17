class PrivateMessage < ApplicationRecord
  validates :content, presence: true

  belongs_to :sender, class_name: "User"
  has_many :private_message_recipients, dependent: :destroy
  has_many :recipients, through: :private_message_recipients, class_name: "User"
end
