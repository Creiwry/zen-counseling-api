# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  puts 'User Loaded'
  before do
    create(:user)
  end

  it { should have_many(:admin_invoices) }
  it { should have_many(:admin_appointments) }

  it { should have_many(:client_invoices) }
  it { should have_many(:client_appointments) }

  it { should have_one(:cart) }
  it { should have_many(:cart_items).through(:cart) }

  it { should have_many(:updates) }

  it { should have_many(:orders) }
  it { should have_many(:order_items).through(:orders) }

  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should allow_value('example@example.com').for(:email) }
  it { should_not allow_value('bad_email').for(:email) }

  it { should validate_inclusion_of(:admin).in_array([true, false]) }

  it 'should be valid when password meets criteria' do
    user = User.new(password: 'Good$123')
    user.valid?
    expect(user.errors[:password]).to be_empty
  end

  it 'should be invalid when password is bad' do
    user = User.new(password: 'badpass')
    user.valid?
    expect(user.errors[:password]).to include('should have more than 6 characters including 1 uppercase letter, 1 number, 1 special character')
  end

  it 'should create a cart on user creation' do
    expect do
      create :user
    end.to change(Cart, :count).by(1)
  end
end
