FactoryBot.define do
  factory :cart_item do
    cart { nil }
    item { nil }
    quantity { 1 }
  end
end
