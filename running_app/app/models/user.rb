class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :height, numericality: { greater_than: 0 }
  validates :weight, numericality: { greater_than: 0 }
  validates :gender, presence: true, inclusion: { in: %w[male female other] }
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true, on: :create

  has_many :runs, dependent: :destroy

  validate :password_confirmation_matches, on: :create

  private 

  def password_confirmation_matches
    if password != password_confirmation
      errors.add(:password_confirmation, "does not match password")
    end
  end
end
