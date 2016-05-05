require 'rails_helper'

describe User::Auth::AuthenticateService do
  let (:existing_user) { create(:user) }

  context 'when user does not exist' do
    it 'should create user' do
      expect { authenticate_service.call }.to change { User.count }.by(1)
    end

    it 'should create new authorization provider' do
      expect { authenticate_service.call }.to change { AuthProvider.count }.by(1)
    end

    it 'should assign auth provider to user' do
      user = authenticate_service.call
      expect(user.auth_providers.count).to eq(1)
    end
  end

  context 'when user exists' do
    it 'should not create new user' do
      create_existing_user
      expect { authenticate_service.call }.not_to change { User.count }
    end

    it 'should create new authorization provider' do
      create_existing_user
      expect { authenticate_service.call }.to change { AuthProvider.count }.by(1)
    end

    it 'should assign auth provider to user' do
      user = create_existing_user
      expect { authenticate_service.call }.to change {
        user.auth_providers.count
      }.by(1)
    end
  end

  it 'should return object kind of User' do
    expect(authenticate_service.call).to be_kind_of(User)
  end

private

  def authenticate_service
    described_class.new(data)
  end

  def create_existing_user
    create(:user, email: 'fakeemail@gmail.com')
  end

  # This data is needed to create user and auth provider
  # through service we are testing
  def data
    {
      name: 'George Chkhvirkia',
      username: 'gioch',
      image: 'www.site.com',
      email: 'fakeemail@gmail.com',
      provider: 'twitter',
      uid: '1234',
    }
  end
end
