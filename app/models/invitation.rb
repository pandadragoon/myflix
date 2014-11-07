class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"
  validates :recipient_name, presence: true
  validates :recipient_email, presence: true
  validates :message, presence: true

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
