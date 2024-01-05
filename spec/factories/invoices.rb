# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    appointment_number { 1 }
    total { '9.99' }
    status { 'unpaid' }
    client { create(:user, admin: false) }
    admin { create(:user, admin: true) }
  end
end
