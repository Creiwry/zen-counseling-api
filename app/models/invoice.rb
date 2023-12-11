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
    self.appointment_number.times do
      Appointment.create!(
        invoice: self,
        admin: self.admin,
        client: self.client,
        link: "this is the link",
        date: DateTime.now + 1.year,
        status: 'unpaid'
      )
    end
  end

  def update_appointments
    self.appointments.each do |appointment|
      if self.status == 'paid'
        appointment.update(status: 'available')
      end
    end
  end
end
