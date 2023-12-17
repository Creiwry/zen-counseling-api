# frozen_string_literal: true

class Invoice < ApplicationRecord
  has_one_attached :document
  after_update :update_appointments
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'

  has_many :appointments

  validates :appointment_number, presence: true, numericality: {
    only_integer: true,
    greater_than: 0
  }
  validates :total, presence: true, numericality: {
    greater_than: 0
  }
  validates :status, presence: true, inclusion: %w[unpaid paid cancelled]

  def create_appointments
    appointment_number.times do
      Appointment.create!(
        invoice: self,
        admin:,
        client:,
        link: 'this is the link',
        datetime: DateTime.now + 1.year,
        status: 'unpaid'
      )
    end
  end

  def update_appointments
    appointments_to_update = Appointment.where(invoice: self)

    appointments_to_update.each do |appointment|
      appointment.update(status: 'available') if status == 'paid'
    end
  end
end
