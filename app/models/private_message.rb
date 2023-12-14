class PrivateMessage < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  has_many :message_recipients
  has_many :recipients, through: :message_recipients

  def self.find_conversation_messages(sender, recipient)
    joins(:message_recipients)
      .where(message_recipients: { recipient: })
      .where(sender:)
  end
end
