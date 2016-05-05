require 'rails_helper'

describe Social::Api::Facebook do
  context 'with correct data' do
    let(:service_call) { described_class.new({ token: fake_token }) }
    let(:data) { service_call.data }

    before(:each) do
      stub_fb_call_and_return_fake_output
    end

    it 'should contain fb user id field' do
      expect(data['id'].present?).to be_truthy
    end

    it 'should contain fb user name field' do
      expect(data['name'].present?).to be_truthy
    end

    it 'should contain fb user email field' do
      expect(data['email'].present?).to be_truthy
    end
  end

  context 'with incorrect data' do
    before(:each) do
      stub_fb_call_and_raise_error
    end

    it 'should throw error' do
      expect { service_call }.to raise_error(NameError)
    end
  end

private

  def stub_fb_call_and_return_fake_output
    allow_any_instance_of(described_class)
      .to receive(:data)
      .and_return(fake_fb_output)
  end

  def stub_fb_call_and_raise_error
    allow_any_instance_of(described_class)
      .to receive(:data)
      .and_raise(Koala::Facebook::AuthenticationError)
  end

  def fake_fb_output
    {
      'id' => FactoryGirl.generate(:id),
      'name' => FFaker::NameMX.full_name,
      'email' => FFaker::Internet.email
    }
  end

  def fake_token
    FactoryGirl.generate(:auth_token)
  end
end
