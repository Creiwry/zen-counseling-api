class Invoice < ApplicationRecord
  has_one_attached :document
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'

  has_many :appointments

  validates :appointment_number, presence: true, numericality: {
    only_integer: true
  }
  validates :total, presence: true, numericality: {
    greater_than: 0
  }
  validates :status, presence: true, inclusion: %w[unpaid paid cancelled]
end
