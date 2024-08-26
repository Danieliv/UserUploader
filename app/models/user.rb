class User < ApplicationRecord
  validates :name, presence: true
  validates :password, presence: true
  validate :password_strength

  private

  def password_strength
    return if password.blank?

    unless password.match?(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{10,16}\z/)
      errors.add(:password, "must be between 10-16 characters, include at least one lowercase letter, one uppercase letter, and one digit")
    end

    if password.match?(/(.)\1\1/)
      errors.add(:password, "cannot contain three repeating characters in a row")
    end
  end
end
