require 'spec_helper'

shared_examples_for 'slugable' do
  let(:slugable) { create(described_class) }

  it 'should generate uniq id' do
    new_slugable = create(described_class, name: slugable.name)
    expect(slugable.slug).not_to eq(new_slugable.slug)
  end

  describe '.slug_candidates' do
    it 'should return correct order' do
      expect(slugable.slug_candidates.first).to eq(:name)
      expect(slugable.slug_candidates.second).to eq(:next_hash_id)
    end
  end
end
