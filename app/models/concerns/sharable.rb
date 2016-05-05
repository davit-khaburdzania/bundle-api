module Sharable
  extend ActiveSupport::Concern

  def shared_with?(user)
    self.shares.find_by({ user: user }).present?
  end

  def not_shared_with?(user)
    !shared_with?(user)
  end

  def share_with(data)
    self.shares.create(user: data[:user], permission: data[:permission])
  end

  def share_by_url!(data)
    if not_shared_by_url?
      self.create_url_share(user: data[:user], permission: data[:permission])
    end
  end

  def shared_by_url?
    self.url_share.present?
  end

  def not_shared_by_url?
    !shared_by_url?
  end
end
