require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it { should respond_to(:document) }

  it { should belong_to(:admin) }
  it { should belong_to(:client) }

  it { should have_many(:appointments) }

  it { should validate_presence_of(:appointment_number) }
  it { should validate_numericality_of(:appointment_number).only_integer.is_greater_than(0) }

  it { should validate_presence_of(:total) }
  it { should validate_numericality_of(:total).is_greater_than(0) }

  it { should validate_presence_of(:status) }
  it {
    should validate_inclusion_of(:status).in_array(
      ['unpaid', 'paid', 'cancelled']
    )
  }
end
