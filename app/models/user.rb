# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :devices, dependent: :nullify

  scope :with_devices, -> { joins(:devices).distinct }
  scope :without_devices, -> { where.missing(:devices) }

  enum role: { user: 0, admin: 1 }

  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :role, presence: true, inclusion: { in: roles.keys }

  def as_dto
    {
      id:,
      email:,
      role:
    }
  end
end
