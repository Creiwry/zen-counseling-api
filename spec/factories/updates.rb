# frozen_string_literal: true

FactoryBot.define do
  factory :update do
    title { 'MyString' }
    content { 'MyText' }
    user { nil }
  end
end
