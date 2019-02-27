class User < ApplicationRecord
  has_secure_password

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
  validates :username, length: { minimum: 5 }, on: :update, if: :username_changed?

  before_create :set_username
  after_create :welcome_email

  def welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

  def set_username
  	self.username = email.split('@').first
  end

  attr_accessor :reset_token

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def generate_token
      SecureRandom.urlsafe_base64
    end
  end

  def create_reset_digest
    self.reset_token = self.class.generate_token
    assign_attributes(reset_digest: self.class.digest(reset_token), reset_sent_at: Time.zone.now)
    save(validate: false)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def password_reset_expired?
    reset_sent_at < 6.hours.ago
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  private

  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = generate_token
    end
  end

  def generate_token
    SecureRandom.urlsafe_base64.to_s
  end
end
