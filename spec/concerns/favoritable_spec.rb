require 'spec_helper'

shared_examples_for 'favoritable' do
  let(:user) { create(:user) }
  let(:favoritable) { create(described_class) }

  describe '.favorite_by' do
    context 'when user has not favorited' do
      it 'should create new favorite' do
        expect { favoritable.favorite_by(user) }
          .to change { favoritable.favorites.count }.by(1)
      end

      it 'should increment favorites count' do
        expect {
          favoritable.favorite_by(user)
          favoritable.reload
        }.to change { favoritable.favorites_count }.by(1)
      end

      it 'should return true' do
        expect(favoritable.favorite_by(user)).to be_truthy
      end
    end

    context 'when user has favorited' do
      before(:each) do
        favoritable.favorite_by(user)
      end

      it 'should not create new favorite' do
        expect { favoritable.favorite_by(user) }
          .not_to change { favoritable.favorites.count }
      end

      it 'should not increment favorites count' do
        expect {
          favoritable.favorite_by(user)
          favoritable.reload
        }.not_to change { favoritable.favorites_count }
      end

      it 'should return true' do
        expect(favoritable.favorite_by(user)).to be_truthy
      end
    end
  end

  describe '.unfavorite_by' do
    context 'when user has favorited' do
      before(:each) do
        favoritable.favorite_by(user)
      end

      it 'should delete favorite' do
        expect { favoritable.unfavorite_by(user) }
          .to change { favoritable.favorites.count }.by(-1)
      end

      it 'should decrement favorites count' do
        expect {
          favoritable.unfavorite_by(user)
          favoritable.reload
        }.to change { favoritable.favorites_count }.by(-1)
      end

      it 'should return true' do
        expect(favoritable.unfavorite_by(user)).to be_truthy
      end
    end

    context 'when user has not favorited' do
      it 'should not delete favorite' do
        expect { favoritable.unfavorite_by(user) }
          .not_to change { favoritable.favorites.count }
      end

      it 'should not decrement favorites count' do
        expect {
          favoritable.unfavorite_by(user)
          favoritable.reload
        }.not_to change { favoritable.favorites_count }
      end

      it 'should return true' do
        expect(favoritable.unfavorite_by(user)).to be_truthy
      end
    end
  end

  describe '.favorited_by?' do
    context 'when user has favorited' do
      it 'should return true' do
        favoritable.favorite_by(user)

        expect(favoritable.favorited_by?(user)).to be_truthy
      end
    end

    context 'when user has not favorited' do
      it 'should return false' do
        expect(favoritable.favorited_by?(user)).to be_falsy
      end
    end
  end

  describe '.not_favorited_by?' do
    context 'when user has favorited' do
      it 'should return false' do
        favoritable.favorite_by(user)

        expect(favoritable.not_favorited_by?(user)).to be_falsy
      end
    end

    context 'when user has not favorited' do
      it 'should return true' do
        expect(favoritable.not_favorited_by?(user)).to be_truthy
      end
    end
  end
end
