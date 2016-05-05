require 'rails_helper'

describe Social::Transformers::Transformer do
  context 'when provider is facebook' do
    context 'with correct data' do
      let(:correct_call) { described_class.new(correct_fb_data) }
      let(:incorrect_call) { described_class.new(incorrect_fb_data) }
      let(:data) { correct_call.data }

      it 'should get correct provider class' do
        expect(correct_call.transformer).to be_a(Social::Transformers::Facebook)
      end

      it 'should contain uid field' do
        expect(data[:uid].present?).to be_truthy
      end

      it 'should contain provider field' do
        expect(data[:provider].present?).to be_truthy
      end

      it 'should have provider field to be equal "facebook"' do
        expect(data[:provider]).to eq('facebook')
      end

      it 'should contain name field' do
        expect(data[:name].present?).to be_truthy
      end

      it 'should contain email field' do
        expect(data[:email].present?).to be_truthy
      end
    end

    context 'with incorrect data' do
      it 'should throw error when provider is incorrect' do
        expect { incorrect_call }.to raise_error(NameError)
      end
    end
  end

private

  def correct_fb_data
    {
      provider: 'facebook',
      data: {
        'id' => FactoryGirl.generate(:id),
        'name' => FFaker::NameMX.full_name,
        'email' => FFaker::Internet.email
      }
    }
  end

  def incorrect_fb_data
    { provider: 'fb' }
  end
end
