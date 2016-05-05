require 'rails_helper'

describe User::Auth::CreateService do
  let (:creator) { create(:user) }

  context 'with valid data' do
    it 'should create new auth provider' do
      expect { create_auth_service_valid.call }.to change {
        AuthProvider.count
      }.by(1)
    end

    it 'should assign auth provider to user' do
      expect { create_auth_service_valid.call }.to change {
        creator.auth_providers.count
      }.by(1)
    end
  end

  private

  def valid_data
    { provider: 'twitter', uid: '1234', username: 'gioch' }
  end

  def invalid_data
    { uid: '1234', username: 'gioch' }
  end

  def create_auth_service_valid
    described_class.new(creator, valid_data)
  end

  def create_auth_service_invalid
    described_class.new(creator, invalid_data)
  end
end
