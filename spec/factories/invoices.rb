FactoryBot.define do
  factory :invoice do
    appointment_number { 1 }
    total { "9.99" }
    status { "MyString" }
    user { nil }
    admin { nil }
  end
end