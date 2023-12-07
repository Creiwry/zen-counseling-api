class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :item

  validates :quantity, presence: true, numericality: {
    only_integer: true
  }
end
