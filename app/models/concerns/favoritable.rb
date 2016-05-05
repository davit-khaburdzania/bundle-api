module Favoritable
  extend ActiveSupport::Concern

  def favorite_by(user)
    return true if self.favorited_by?(user)

    self.transaction do
      self.favorites.build({ user: user })
      result = self.save

      self.reload
      result
    end
  end

  def unfavorite_by(user)
    return true if self.not_favorited_by?(user)

    self.transaction do
      favorited = self.favorites.find_by({ user: user })
      result = favorited.destroy

      self.reload
      result
    end
  end

  def favorited_by?(user)
    self.favorites.find_by({ user: user }).present?
  end

  def not_favorited_by?(user)
    !favorited_by?(user)
  end
end
