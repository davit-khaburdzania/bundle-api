require 'rails_helper'

describe Bundle, type: :model do
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
    it { is_expected.to have_many(:links).dependent(:destroy) }
    it { is_expected.to have_many(:shares).dependent(:destroy) }
    it { is_expected.to have_many(:invites).dependent(:destroy) }
    it { is_expected.to have_many(:favorites).dependent(:destroy) }
    it { is_expected.to belong_to(:collection) }
    it { is_expected.to belong_to(:creator) }
  end

  context 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for :links }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'scopes' do
    it 'should have default scope' do
       expect(Bundle.all.order_values).to include('created_at DESC')
    end
  end

  describe 'callbacks' do
    it 'should increment bundles_count in collection' do
      collection = create(:collection)

      expect { create(:bundle, collection: collection) }
        .to change{ collection.bundles_count }.by(1)
    end
  end
end
