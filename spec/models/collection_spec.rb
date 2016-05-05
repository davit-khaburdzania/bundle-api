require 'rails_helper'

describe Collection, type: :model do
  it_should_behave_like 'slugable'
  it_should_behave_like 'sharable'
  it_should_behave_like 'invitable'
  it_should_behave_like 'favoritable'

  describe 'included modules' do
    it 'includes Slugable' do
      expect(described_class.includes(Slugable)).to be_truthy
    end

    it 'includes Sharable' do
      expect(described_class.includes(Sharable)).to be_truthy
    end

    it 'includes Invitable' do
      expect(described_class.includes(Invitable)).to be_truthy
    end

    it 'includes Favoritable' do
      expect(described_class.includes(Favoritable)).to be_truthy
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:bundles).dependent(:destroy) }
    it { is_expected.to have_many(:shares).dependent(:destroy) }
    it { is_expected.to have_many(:invites).dependent(:destroy) }
    it { is_expected.to have_many(:favorites).dependent(:destroy) }
    it { is_expected.to belong_to(:creator) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
