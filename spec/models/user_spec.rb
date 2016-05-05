require 'rails_helper'

describe User, type: :model do
  let(:user_auth_token) { FactoryGirl.generate(:auth_token) }
  let(:invalid_user) { build(:user, email: nil) }
  let(:valid_user) { build(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:collections).dependent(:destroy) }
    it { is_expected.to have_many(:favorites).dependent(:destroy) }
    it { is_expected.to have_many(:bundles).dependent(:destroy) }
    it { is_expected.to have_many(:links)
      .with_foreign_key(:creator_id)
      .dependent(:destroy)
    }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe 'dependents' do
    it 'should destroy dependent auth providers' do
      user = create(:user)
      auth_provider = create(:auth_provider, user: user)

      expect { user.destroy }.to change { AuthProvider.count }.by(-1)
    end
  end

  describe 'instance methods' do
    context '#token_set?' do
      context 'when token is set' do
        it 'should return true' do
          user = create(:user, auth_token: :user_auth_token)

          expect(user.token_set?).to be_truthy
        end
      end

      context 'when token is not set' do
        it 'should return false' do
          user = create(:user, auth_token: nil)

          expect(user.token_set?).to be_falsy
        end
      end
    end

    context '#token_not_set?' do
      context 'when token is set' do
        it 'should return false' do
          user = create(:user, auth_token: :user_auth_token)

          expect(user.token_not_set?).to be_falsy
        end
      end

      context 'when token is not set' do
        it 'should return true' do
          user = create(:user, auth_token: nil)

          expect(user.token_not_set?).to be_truthy
        end
      end
    end

    context '#destroy_auth_token!' do
      it 'should set token to nil' do
        user = create(:user, auth_token: :user_auth_token)
        user.destroy_auth_token!

        expect(user.auth_token).to be_nil
      end
    end

    context '#any_errors?' do
      context 'when token is created correctly' do
        it 'should return false' do
          valid_user.save

          expect(valid_user.any_errors?).to be_falsy
        end
      end

      context 'when token is not created correctly' do
        it 'should return true' do
          invalid_user.save

          expect(invalid_user.any_errors?).to be_truthy
        end
      end
    end

    context '#no_errors?' do
      context 'when token is created correctly' do
        it 'should return false' do
          valid_user.save

          expect(valid_user.no_errors?).to be_truthy
        end
      end

      context 'when token is not created correctly' do
        it 'should return true' do
          invalid_user.save

          expect(invalid_user.no_errors?).to be_falsy
        end
      end
    end
  end
end
