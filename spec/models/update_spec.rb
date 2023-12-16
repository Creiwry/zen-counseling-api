require 'rails_helper'

RSpec.describe Update, type: :model do
  it { should respond_to(:image) }

  it { should belong_to(:admin) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(50) }

  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_most(1000) }
end
