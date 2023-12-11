class Appointment < ApplicationRecord
  belongs_to :invoice
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'

  validates_datetime :date, on_or_after: -> { Date.current }

  validates :link, presence: true
  validates :status, presence: true, inclusion: ['unpaid', 'booked', 'available', 'past', 'cancelled']
end
