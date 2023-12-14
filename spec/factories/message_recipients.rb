FactoryBot.define do
  factory :message_recipient do
    private_message { nil }
    users { nil }
  end
end
