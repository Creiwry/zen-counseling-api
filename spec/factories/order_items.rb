# frozen_string_literal: true

FactoryBot.define do
  factory :order_item do
    order { nil }
    item { nil }
  end
end
