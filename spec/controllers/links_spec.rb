require 'rails_helper'

describe LinksController, type: :controller do
  let(:incorrect_id) { 98822512 }
  let(:current_user) { create(:user) }

  context 'when auth filter is off' do
    before :each do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    describe 'GET #show' do
      context 'with correct id' do
        it 'should render correct link as json' do
          link = create(:link, creator: current_user)

          get :show, params: { id: link.id }

          expect(response).to be_success
          expect(response).to serialize_object(link).with(LinkSerializer)
        end
      end

      context 'incorrect link id' do
        it 'should respond wih 404' do
          get :show, params: { id: incorrect_id }

          expect(response).to have_status(:not_found)
          expect(parse_response['errors']).to eq([I18n.t('error_not_found')])
        end
      end
    end

    describe 'POST #create' do
      context 'with correct data' do
        it 'should create link' do
          bundle = create(:bundle, creator: current_user)

          payload = {
            title: FFaker::Name.name,
            description: FFaker::Lorem.sentence,
            image: FFaker::Avatar.image,
            bundle_id: bundle.id
          }

          expect { post :create, { params: payload } }
            .to change { Link.count }.by(1)
        end

        it 'should render correct link as json' do
          bundle = create(:bundle, creator: current_user)

          payload = {
            title: FFaker::Name.name,
            description: FFaker::Lorem.sentence,
            image: FFaker::Avatar.image,
            bundle_id: bundle.id
          }

          post :create, params: payload

          link = Link.find(parse_response['id'])

          expect(response).to be_success
          expect(response).to serialize_object(link).with(LinkSerializer)
        end
      end

      context 'with incorrect data' do
        it 'should render errors json' do
          payload = { title: nil }

          post :create, params: payload

          expect(response).to have_status(:not_acceptable)
          expect(parse_response['errors']).not_to be_empty
        end
      end
    end

    describe 'PUT #update' do
      context 'with correct data' do
        it 'should update link' do
          bundle = create(:bundle, creator: current_user)
          link = create(:link, creator: current_user)
          payload = { title: FFaker::Name.name, id: link }

          put :update, params: payload
          link.reload

          expect(link.title).to eq(payload[:title])
        end

        it 'should render correct bundle as json' do
          bundle = create(:bundle, creator: current_user)
          link = create(:link, creator: current_user)
          payload = { title: FFaker::Name.name, id: link }

          put :update, params: payload

          link.reload

          expect(response).to be_success
          expect(response).to serialize_object(link).with(LinkSerializer)
        end
      end

      context 'with incorrect data' do
        it 'should render errors json' do
          bundle = create(:bundle, creator: current_user)
          link = create(:link, creator: current_user)
          payload = { title: nil, id: link }

          post :update, params: payload

          expect(response).to have_status(:not_acceptable)
          expect(parse_response['errors']).not_to be_empty
        end
      end

      context 'with incorrect id' do
        it 'should return 404 and render errors' do
          put :update, params: { id: incorrect_id }

          expect(response).to have_status(:not_found)
          expect(parse_response['errors']).to eq([I18n.t('error_not_found')])
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'with correct bundle id' do
        it 'should destroy bundle' do
          bundle = create(:bundle, creator: current_user)
          link = create(:link, creator: current_user)

          expect { delete :destroy, params: { id: link } }
            .to change { Link.count }.by(-1)
        end

        it 'should render success' do
          bundle = create(:bundle, creator: current_user)
          link = create(:link, creator: current_user)

          delete :destroy, params: { id: link }

          expect(parse_response['success']).to be_truthy
        end
      end

      context 'incorrect bundle id' do
        it 'should return 404 and render errors' do
          delete :destroy, params: { id: incorrect_id }

          expect(response).to have_status(:not_found)
          expect(parse_response['errors']).to eq([I18n.t('error_not_found')])
        end
      end
    end
  end

  context 'when auth filter is on' do
    data = { id: 1 }
    
    it { is_expected.to execute_before_action :authenticate!,
      on: :create, via: :post }

    it { is_expected.to execute_before_action :authenticate!,
      on: :show, via: :get, with: data }

    it { is_expected.to execute_before_action :authenticate!,
      on: :update, via: :put, with: data }

    it { is_expected.to execute_before_action :authenticate!,
      on: :destroy, via: :delete, with: data }
  end

  def parse_response
    JSON.parse(response.body)
  end
end
