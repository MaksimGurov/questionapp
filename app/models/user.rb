# frozen_string_literal: true

# программный код

class User < ApplicationRecord
  attr_accessor :old_password # виртуальный атрибут на объекте юзер

  has_secure_password validations: false

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  validate :password_presence
  validate :correct_old_password, on: :update, if: -> { password.present? }
  validates :password, confirmation: true, allow_blank: true,
                       length: { minimum: 8, maximum: 70 }

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  validate :password_complexity

  private

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end

  def password_complexity
    # https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    msg = 'complexity requirement not met. Length should be 8-70 characters and' \
          'include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    errors.add :password, msg
  end

  def password_presence
    errors.add(:password, :blank) unless password_digest.present?
  end
end
