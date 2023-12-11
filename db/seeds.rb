# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

OrderItem.destroy_all
CartItem.destroy_all
Appointment.destroy_all
Invoice.destroy_all
Update.destroy_all
Order.destroy_all
Item.destroy_all
Cart.destroy_all
User.destroy_all

puts 'User'
puts 'Cart'
10.times do
  User.create!(
    admin: false,
    email: Faker::Internet.email,
    password: 'Password!23',
    username: Faker::Internet.username.slice(0, 9)
  )
  # Cart.create!(user:)
end

carts = Cart.all
users = User.all

puts 'Item'
puts 'Cart Item'
30.times do
  item = Item.create!(
    title: Faker::Lorem.words(number: 2).join(' '),
    description: Faker::Lorem.paragraph,
    price: Faker::Number.decimal(l_digits: 2),
    stock: Faker::Number.within(range: 10..100)
  )
  CartItem.create!(
    item:,
    cart: carts.sample,
    quantity: Faker::Number.within(range: 1..5)
  )
end

puts 'Order'
puts 'Order Item'
carts.each do |cart|
  order = Order.new(
    user: cart.user,
    stripe_customer_id: '',
    total: 0,
    address: Faker::Address.full_address,
    status: 'unpaid'
  )
  cart.cart_items.each do |cart_item|
    cart_item.quantity.times do
      order.items << cart_item.item
      order.total += cart_item.item.price
      order.save!
    end
  end
end

admin = users.sample
admin.update!(admin: true)
users_not_admin = users.reject { |user| user == admin }

puts 'Update'
5.times do
  Update.create!(
    admin:,
    title: Faker::Lorem.words(number: 3).join(' ').slice(0, 20),
    content: Faker::Lorem.paragraph
  )
end

puts 'Invoice'
puts 'Appointment'
20.times do
  invoice = Invoice.create!(
    appointment_number: Faker::Number.within(range: 2..5),
    total: Faker::Number.within(range: 200..500),
    client: users_not_admin.sample,
    admin:,
    status: 'unpaid'
  )

  invoice.appointment_number.times do
    Appointment.create!(
      client: invoice.client,
      admin: invoice.admin,
      invoice:,
      date: Faker::Date.forward,
      link: 'this is the appointment link',
      status: 'available'
    )
  end
end
