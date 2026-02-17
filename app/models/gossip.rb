class Gossip < ApplicationRecord
  validates :title, presence: true, length: { in: 3..14 }
  validates :content, presence: true

  has_one_attached :image

  belongs_to :user
  has_many :join_table_gossip_tags, dependent: :destroy
  has_many :tags, through: :join_table_gossip_tags
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
end
