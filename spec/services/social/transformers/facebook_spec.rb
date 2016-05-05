require 'rails_helper'

describe Social::Transformers::Facebook do
  let(:correct_call) { described_class.new(input) }
  let(:data) { correct_call.data }

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

private

  def input
    {
      'id' => FactoryGirl.generate(:id),
      'name' => FFaker::NameMX.full_name,
      'email' => FFaker::Internet.email
    }
  end
end
