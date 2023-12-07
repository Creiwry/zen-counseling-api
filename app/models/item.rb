class Item < ApplicationRecord
  has_many_attached :images

  has_many :cart_items
  has_many :carts, through: :cart_items

  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, presence: true, length: {
    maximum: 25
  }
  validates :description, presence: true, length: {
    maximum: 1000
  }

  validates :price, presence: true, numericality: {
    greater_than: 0
  }

  validates :stock, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
end
