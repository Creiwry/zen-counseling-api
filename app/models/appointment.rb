class Appointment < ApplicationRecord
  belongs_to :invoice
  before_destroy :check_conditions
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'

  validates_datetime :datetime, on_or_after: -> { Date.current }

  validates :link, presence: true
  validates :status, presence: true, inclusion: %w[unpaid confirmed available past cancelled unconfirmed]

  def date
    datetime.to_date
  end

  def self.filter_based_on_date(filter_date)
    where('DATE(datetime) = ?', filter_date)
  end

  def attach_information_of_other_user(user_type)
    other_user = user_type == 'admin' ? "#{client.first_name} #{client.last_name}" : "#{admin.first_name} #{admin.last_name}" 
    self.as_json.merge(other_user_name: other_user)
  end

  # def check_conditions
  #   raise 'cannot destroy appointment' unless status == 'past' || status == ''
  # end

  def time
    datetime.strftime('%H:%M:%S %z')
  end
end
