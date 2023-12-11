FactoryBot.define do
  factory :order do
    user { nil }
    stripe_customer_id { "MyString" }
    total { "9.99" }
    address { "MyString" }
    status { "unpaid" }
  end
end
