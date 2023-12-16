class Update < ApplicationRecord
  has_one_attached :image
  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  validates :title, presence: true, length: {
    maximum:50 
  }

  validates :content, presence: true, length: {
    maximum: 1000
  }
end
