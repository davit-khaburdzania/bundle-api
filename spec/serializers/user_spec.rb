require 'rails_helper'

describe UserSerializer do
  let(:user) { create(:user) }

  subject { serialize(user) }

  it 'should have basic attributes' do
    attrs = ['id', 'name', 'email', 'image', 'auth_token']

    attrs.each do |attr|
      expect(subject[attr]).to eq(user[attr])
    end
  end
end
