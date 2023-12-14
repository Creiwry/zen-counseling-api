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

  has_many :sent_messages, class_name: 'PrivateMessage', foreign_key: 'sender_id'
  has_many :message_recipients, foreign_key: :recipient_id
  has_many :received_messages, through: :message_recipients, source: :private_message

  validates :admin, inclusion: [true, false]
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_with Validators::PasswordRegexValidator

  def create_cart
    Cart.create!(user: self)
  end

  def send_message(recipient, content)
    message = PrivateMessage.create(sender: self, content:)
    MessageRecipient.create(private_message: message, recipient:)
    message
  end
end
