FactoryBot.define do
  factory :order_item do
    order { nil }
    item { nil }
    total { "9.99" }
  end
end
