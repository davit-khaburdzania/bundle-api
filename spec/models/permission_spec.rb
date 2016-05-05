require 'rails_helper'

describe Permission, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:invites) }
    it { is_expected.to have_many(:shares) }
    it { is_expected.to have_many(:url_shares) }
  end
end
