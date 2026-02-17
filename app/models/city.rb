class City < ApplicationRecord
  validates :name, presence: true
  validates :zip_code, presence: true, format: { with: /\A[\d\-]+\z/, message: "doit contenir uniquement des chiffres et tirets" }

  has_many :users
end
