require_dependency 'validators/password_regex_validator'

class User < ApplicationRecord
  after_create :create_cart
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :admin_invoices, class_name: 'Invoice', foreign_key: 'admin_id'
  has_many :admin_appointments, class_name: 'Appointment', foreign_key: 'admin_id'

  has_many :client_invoices, class_name: 'Invoice', foreign_key: 'client_id'
  has_many :client_appointments, class_name: 'Appointment', foreign_key: 'client_id'

  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart

  has_many :updates, foreign_key: 'admin_id'

  has_many :orders
  has_many :order_items, through: :orders

  validates :admin, inclusion: [true, false]
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
   

  validates_with Validators::PasswordRegexValidator

  def create_cart
    Cart.create!(user: self)
  end
end
