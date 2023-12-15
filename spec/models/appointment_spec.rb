require 'rails_helper'

RSpec.describe Appointment, type: :model do

  it { should belong_to(:invoice) }

  it { should belong_to(:admin) }

  it { should belong_to(:client) }

  # it { should validate_presence_of(:datetime) }

  it { should validate_presence_of(:link) }

  it { should validate_presence_of(:status) }

  # it {
  #   should validate_inclusion_of(:status).in_array(
  #     ['booked', 'available', 'past', 'cancelled', 'unconfirmed']
  #   )
  # }
end
