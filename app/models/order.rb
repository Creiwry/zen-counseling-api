class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items
  has_many :items, through: :order_items

  validates :total, presence: true, numericality: {
    greater_than: 0
  }
  validates :address, presence: true
  validates :status, presence: true, inclusion: ['unpaid', 'paid', 'sent', 'cancelled', 'refunded', 'delivered']
end
