class Appointment < ApplicationRecord
  belongs_to :invoice
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'

  validates_datetime :datetime, on_or_after: -> { Date.current }

  validates :link, presence: true
  validates :status, presence: true, inclusion: ['unpaid', 'booked', 'available', 'past', 'cancelled']

  def date
    datetime.to_date
  end

  def self.filter_based_on_date(filter_date)
    where('DATE(datetime) = ?', filter_date)
  end

  def time
    datetime.strftime('%H:%M:%S %z')
  end
end
