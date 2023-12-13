FactoryBot.define do
  factory(:user) do
    username { Faker::Internet.username.slice(0, 9) }
    email { Faker::Internet.email }
    password { 'Password!23' }
    admin { false }
  end
end
