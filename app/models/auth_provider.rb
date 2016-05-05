class AuthProvider < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true

  def any_errors?
    self.errors.any?
  end

  def no_errors?
    self.errors.blank?
  end
end
