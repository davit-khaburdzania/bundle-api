require 'rails_helper'

describe Social::Api::Client do
  let(:correct_fb_client_call) do
    described_class.new({ provider: 'facebook', token: fake_token })
  end

  let(:incorrect_provider_fb_client_call) do
    described_class.new({ provider: 'xx' })
  end

  context 'when provider is facebook' do
    context 'with correct data' do
      let(:data) { correct_fb_client_call.data }

      before(:each) do
        stub_fb_api_call_and_return_fake_output
      end

      it 'should get correct provider class' do
        expect(correct_fb_client_call.client).to be_a(Social::Api::Facebook)
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
      it 'should throw error when provider is incorrect' do
        expect { incorrect_provider_fb_client_call }.to raise_error(NameError)
      end
    end
  end

private

  def stub_fb_api_call_and_return_fake_output
    allow_any_instance_of(Social::Api::Facebook)
      .to receive(:data)
      .and_return(fake_fb_output)
  end

  def stub_fb_api_call_and_raise_error
    allow_any_instance_of(Social::Api::Facebook)
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
