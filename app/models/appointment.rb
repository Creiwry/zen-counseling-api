class Appointment < ApplicationRecord
  belongs_to :invoice
  belongs_to :user
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
end
