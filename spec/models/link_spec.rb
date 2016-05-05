require 'rails_helper'

describe Link, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:bundle) }
    it { is_expected.to belong_to(:creator) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_least(3) }
  end

  describe 'callbacks' do
    it 'should increment links_count in collection' do
      bundle = create(:bundle)

      expect { create(:link, bundle: bundle) }
        .to change{ bundle.links_count }.by(1)
    end
  end
end
