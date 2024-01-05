# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    invoice { create(:invoice) }
    client { invoice.client }
    admin { invoice.admin }
    datetime { DateTime.now + 3.days }
    link { 'https://zoom.us/mylink' }
    status { 'available' }
  end
end
