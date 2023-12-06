class Invoice < ApplicationRecord
  has_one_attached :document
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
  belongs_to :client, class_name: 'User', foreign_key: 'client_id'

  has_many :appointments
end
