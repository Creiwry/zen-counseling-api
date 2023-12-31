# frozen_string_literal: true

class Cart < ApplicationRecord
  belongs_to :user

  has_many :cart_items
  has_many :items, through: :cart_items

  def cart_items_display
    display_items_array = []
    cart_items.each do |cart_item|
      if cart_item.item.images.attached?
        puts 'image attached'
        puts cart_item.item.images[0]
        image_url = url_for(cart_item.item.images[0])
      else
        image_url = nil
      end
      item = {
        cart_item_id: cart_item.id,
        item_id: cart_item.item_id,
        name: cart_item.item.title,
        description: cart_item.item.description,
        quantity: cart_item.quantity,
        image: image_url,
        total_price: cart_item.quantity * cart_item.item.price
      }
      display_items_array << item
    end
    display_items_array
  end

  def create_order(address)
    order = Order.new(
      user:,
      stripe_customer_id: user.orders.last ? user.orders.last.stripe_customer_id : '',
      total: 0,
      address:,
      status: 'unpaid'
    )

    cart_items.each do |cart_item|
      cart_item.quantity.times do
        order.items << cart_item.item
        order.total += cart_item.item.price
      end
    end

    return order.check_stock unless order.check_stock[:success] == true

    cart_items.destroy_all

    order.save!

    { success: true, order: }
  end
end
