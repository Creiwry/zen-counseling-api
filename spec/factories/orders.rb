# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user { nil }
    stripe_customer_id { 'MyString' }
    total { '9.99' }
    status { 'unpaid' }
  end
end
