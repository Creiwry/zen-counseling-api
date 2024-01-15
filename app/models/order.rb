# frozen_string_literal: true

require_dependency 'validators/country_name_validator'

class Order < ApplicationRecord
  before_save :update_item_stock
  belongs_to :user

  has_many :order_items
  has_many :items, through: :order_items

  validates :total, presence: true, numericality: {
    greater_than: 0
  }
  validates :status, presence: true, inclusion: %w[unpaid paid sent cancelled refunded delivered]

  validates :zip_code, length: { maximum: 10 }
  validates :city, format: { with: /\A[a-zA-Z\u0080-\u024F]+(?:[. \-]|[' ]|[a-zA-Z\u0080-\u024F])*\z/ }
  validates :street_address, format: { with: /\A\s*\S.*\z/ }
  validates_with Validators::CountryNameValidator

  def stripe_line_items
    line_items_stripe = []
    order_items_to_checkout = OrderItem.where(order: self)
    order_items_to_checkout.map do |order_item|
      entry =
        {
          price_data: {
            currency: ENV.fetch('DEFAULT_CURRENCY', 'usd'),
            unit_amount: (order_item.item.price * 100).to_i,
            product_data: {
              name: order_item.item.title
            }
          },
          quantity: 1
        }
      line_items_stripe << entry
    end

    line_items_stripe
  end

  def order_item_quantity
    order_items.group(:item_id).count
  end

  def check_stock
    order_item_quantity.each do |item_id, quantity|
      puts item_id
      item = Item.find(item_id)
      return { success: false, status: "Out of Stock: #{item.title}" } unless item.stock - quantity.to_i >= 0
    end
    { success: true, status: 'In Stock' }
  end

  def update_item_stock
    return unless status_changed? && status_change_to_be_saved == %w[unpaid paid]

    order_item_quantity.each do |item_id, quantity|
      item = Item.find(item_id)
      item.update!(stock: item.stock - quantity)
    end
  end
end
