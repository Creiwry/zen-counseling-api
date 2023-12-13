class Order < ApplicationRecord
  before_save :update_item_stock
  belongs_to :user

  has_many :order_items
  has_many :items, through: :order_items

  validates :total, presence: true, numericality: {
    greater_than: 0
  }
  validates :address, presence: true
  validates :status, presence: true, inclusion: ['unpaid', 'paid', 'sent', 'cancelled', 'refunded', 'delivered']

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
    return order_items.group(:item_id).count
  end

  def check_stock
    self.order_item_quantity.each do |item_id, quantity|
      puts item_id
      item = Item.find(item_id)
      return { success: false, status: "Out of Stock: #{item.title}" } unless item.stock - quantity.to_i >= 0
    end
    { success: true, status: 'In Stock' }
  end

  def update_item_stock
    if status_changed? && status_change_to_be_saved == ['unpaid', 'paid']
      self.order_item_quantity.each do |item_id, quantity|
        item = Item.find(item_id)
        item.update!(stock: item.stock - quantity)
      end
    end
  end
end
