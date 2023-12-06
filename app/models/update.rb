class Update < ApplicationRecord
  has_one_attached :image
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'
end
