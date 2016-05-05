require 'rails_helper'

describe User::CreateService do
  context 'when user does not exist' do
    it 'should create new' do
      user_count = User.count
      new_user = create_user_service.call

      expect(User.count).to eq(user_count + 1)
      expect(new_user.name).to eq(data[:name])
      expect(new_user.username).to eq(data[:username])
      expect(new_user.image).to eq(data[:image])
      expect(new_user.email).to eq(data[:email])
    end
  end

  it 'should return object kind of User' do
    user_obj = create_user_service.call
    expect(user_obj).to be_kind_of(User)
  end

private

  def data
    {
      name: 'George',
      username: 'gioch',
      image: 'www.site.com/img',
      email: 'fakeemail@gmail.com'
    }
  end

  def create_user_service
    described_class.new(data)
  end
end
