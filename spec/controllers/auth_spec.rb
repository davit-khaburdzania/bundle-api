require 'rails_helper'

describe AuthController, type: :controller do
  context 'when auth filter is off' do
    describe 'POST #create' do
      context 'when provider is facebook' do
        context 'with correct data' do
          before(:each) do
            stub_fb_client_and_return_fake_output
            post :create, params: correct_fb_payload_data
          end

          it 'should render success' do
            expect(response).to be_success
          end

          it 'should render user data json' do
            user = User.find(parse_response['id'])

            expect(response).to serialize_object(user).with(UserSerializer)
          end
        end

        context 'with incorrect data' do
          before(:each) do
            stub_fb_client
          end

          context 'when token not valid' do
            before(:each) do
              post :create, params: { provider: fb, token: auth_token }
            end

            it 'should render errors json' do
              expect(parse_response['errors']).not_to be_empty
            end

            it 'should have status unprocessable' do
              expect(response).to have_status(:unprocessable_entity)
            end
          end

          context 'when token not provided' do
            before(:each) do
              post :create, params: { provider: fb }
            end

            it 'should render errors json' do
              expect(parse_response['errors']).not_to be_empty
            end

            it 'should have status unprocessable' do
              expect(response).to have_status(:unprocessable_entity)
            end
          end

          context 'when provider not provided' do
            before(:each) do
              post :create, params: { token: auth_token }
            end

            it 'should render errors json' do
              expect(parse_response['errors']).not_to be_empty
            end

            it 'should have status unprocessable' do
              expect(response).to have_status(:unprocessable_entity)
            end
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'when user authorized' do
        it 'should destroy user token' do
          user = create(:user, auth_token: auth_token)

          delete :destroy, params: { auth_token: user.auth_token }
          user.reload

          expect(user.auth_token).to be_nil
        end

        it 'should render success' do
          user = create(:user, auth_token: auth_token)

          delete :destroy, params: { auth_token: user.auth_token }

          expect(response).to be_success
        end
      end

      context 'when user unauthorized' do
        it 'should not destroy user token' do
          user = create(:user, auth_token: nil)

          delete :destroy, params: { auth_token: auth_token }
          user.reload

          expect(user.auth_token).to be_nil
        end

        it 'should render error' do
          user = create(:user, auth_token: nil)

          delete :destroy, params: { auth_token: auth_token }

          expect(response).to have_status(:not_acceptable)
        end
      end
    end
  end

  context 'when auth filter is on' do
    it { is_expected.to execute_before_action :authenticate!,
      on: :destroy, via: :delete }
  end

private

  def stub_fb_client_and_return_fake_output
    allow_any_instance_of(Social::Api::Facebook)
      .to receive(:data)
      .and_return(fake_fb_client_output)
  end

  def stub_fb_client
    allow_any_instance_of(Social::Api::Facebook)
      .to receive(:data)
      .and_return({})
  end

  def fake_fb_client_output
    {
      'id' => FactoryGirl.generate(:uid),
      'name' => FFaker::NameMX.full_name,
      'email' => FFaker::Internet.email,
    }
  end

  def correct_fb_payload_data
    {
      provider: fb,
      token: auth_token
    }
  end

  def fb
    'facebook'
  end

  def auth_token
    FactoryGirl.generate(:auth_token)
  end

  def parse_response
    JSON.parse(response.body)
  end
end
