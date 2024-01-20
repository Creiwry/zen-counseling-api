# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should belong_to(:user) }

  it { should have_many(:order_items) }
  it { should have_many(:items).through(:order_items) }

  it { should validate_presence_of(:total) }
  it { should validate_numericality_of(:total).is_greater_than(0) }

  it { should validate_presence_of(:status) }
  it {
    should validate_inclusion_of(:status).in_array(
      %w[unpaid paid sent cancelled refunded delivered]
    )
  }
end
