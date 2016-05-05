module Invitable
  extend ActiveSupport::Concern

  def invited?(user)
    find_invite_for(user).present?
  end

  def not_invited?(user)
    !invited?(user)
  end

  def invite(data)
    self.invites.create(
      inviter: data[:inviter],
      invited: data[:invited],
      email: data[:email],
      permission: data[:permission],
      token: unique_token
    )
  end

  def find_invite_for(user)
    self.invites.find_by({ invited: user })
  end

private

  def unique_token
    SecureRandom.base58(100)
  end
end
