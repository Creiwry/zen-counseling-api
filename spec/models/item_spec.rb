require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should respond_to(:images) }

  it { should have_many(:cart_items) }
  it { should have_many(:carts).through(:cart_items) }

  it { should have_many(:order_items) }
  it { should have_many(:orders).through(:order_items) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(50) }

  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_most(1000) }

  it { should validate_numericality_of(:price).is_greater_than(0) }

  it { should validate_numericality_of(:stock).only_integer.is_greater_than_or_equal_to(0) }
end
