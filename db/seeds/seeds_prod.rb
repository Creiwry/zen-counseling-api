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

ray = User.create!(
  admin: true,
  email: 'ray.toro@mychem.com',
  password: 'Password!23',
  first_name: 'Ray',
  last_name: 'Toro'
)

frank = User.create!(
  admin: true,
  email: 'frank.iero@mychem.com',
  password: 'Password!23',
  first_name: 'Frank',
  last_name: 'Iero'
)

gee = User.create!(
  admin: true,
  email: 'gee.way@mychem.com',
  password: 'Password!23',
  first_name: 'Gerard',
  last_name: 'Way'
)

User.create!(
  admin: true,
  email: 'mikey.way@mychem.com',
  password: 'Password!23',
  first_name: 'Michael',
  last_name: 'Way'
)

billie = User.create!(
  admin: true,
  email: 'billie.joe.armstrong@greenday.com',
  password: 'Password!23',
  first_name: 'Billie Joe',
  last_name: 'Armstrong'
)

5.times do
  User.create!(
    admin: false,
    email: Faker::Internet.email,
    password: 'Password!23',
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end

# Counseling Resources
Item.create!(
  title: "Stress Relief Journal",
  description: "A guided journal to help manage stress and reflect on daily experiences.",
  price: 19.99,
  stock: 50
)

# Mindfulness Cards
Item.create!(
  title: "Mindful Moments Cards",
  description: "Deck of cards with daily mindfulness exercises for promoting mental well-being.",
  price: 14.99,
  stock: 30
)

# Anxiety Workbook
Item.create!(
  title: "Overcoming Anxiety Workbook",
  description: "A comprehensive workbook with strategies and exercises for managing anxiety.",
  price: 24.99,
  stock: 40
)

# Meditation Cushion
Item.create!(
  title: "Zen Meditation Cushion",
  description: "Comfortable cushion for creating a serene space for meditation and relaxation.",
  price: 34.99,
  stock: 20
)

# Guided Therapy Journal
Item.create!(
  title: "Therapeutic Reflection Journal",
  description: "Journal designed for guided self-reflection and therapeutic writing.",
  price: 22.99,
  stock: 35
)

# Positive Affirmation Cards
Item.create!(
  title: "Affirmation Deck for Positivity",
  description: "Cards with uplifting affirmations to promote positive thinking and mental health.",
  price: 16.99,
  stock: 45
)

# Stress Ball Set
Item.create!(
  title: "Stress Relief Squeeze Balls",
  description: "Set of stress balls for physical relief and relaxation during tense moments.",
  price: 12.99,
  stock: 60
)

# Sleep Sound Machine
Item.create!(
  title: "Sleep Therapy Sound Machine",
  description: "Machine with calming sounds to aid relaxation and improve sleep quality.",
  price: 29.99,
  stock: 25
)

# Emotional Well-being Book
Item.create!(
  title: "Emotional Resilience Guide",
  description: "Book offering insights and practices for building emotional resilience.",
  price: 18.99,
  stock: 50
)

# Online Counseling Session Voucher
Item.create!(
  title: "Virtual Counseling Session Voucher",
  description: "Voucher for a virtual counseling session with a certified therapist.",
  price: 49.99,
  stock: 15
)

puts 'Update'
Update.create!(
  admin: ray,
  title: 'Workshop on Mindfullness',
  content: 'On the 15th of February, a workshop will be available for all users who register. The workshop will be on the practice of mindfullness. please register at the following link, as places are limited.'
)

Update.create!(
  admin: gee,
  title: 'New books in store soon',
  content: 'New books on family dinamics will be available in the store next month'
)

Update.create!(
  admin: frank,
  title: 'New video on building confidence',
  content: 'A new video on building confidence is available on our official youtube channel'
)
