# frozen_string_literal: true

FactoryBot.define do
  factory(:user) do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    full_name { 'Full Name' }
    email { Faker::Internet.email }
    password { 'Password!23' }
    admin { false }
  end
end
