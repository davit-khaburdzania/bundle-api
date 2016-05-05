module Slugable
  extend ActiveSupport::Concern

  included do
    extend FriendlyId
    friendly_id :slug_candidates, use: [:slugged]

    def normalize_friendly_id(text)
      text.to_s.to_slug.normalize.to_s
    end

    def should_generate_new_friendly_id?
      name_changed?
    end
  end

  def slug_candidates
    [:name, :next_hash_id]
  end

private
  def next_hash_id
    hashid = Hashids.new.encode(current_time)
    "#{self.name}-#{hashid}"
  end

  def current_time
    (Time.current.to_f * 1000).to_i
  end
end
