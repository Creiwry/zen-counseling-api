class Appointment < ApplicationRecord
  belongs_to :invoice
  belongs_to :user
  belongs_to :admin
end
