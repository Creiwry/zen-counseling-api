FactoryBot.define do
  factory :appointment do
    invoice { nil }
    user { nil }
    admin { nil }
    date { "2024-12-06 10:17:45" }
    link { "MyString" }
    status { "available" }
  end
end
