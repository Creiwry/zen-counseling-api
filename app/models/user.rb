class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :invoices
  has_many :appointments, through: :invoices

  has_many :invoices, foreign_key: 'admin_id'
  has_many :appointments, through: :invoices, foreign_key: 'admin_id'

  has_one :cart
  has_many :cart_items, through: :cart

  has_many :updates

  has_many :orders
  has_many :order_items, through: :orders
end
