require 'rails_helper'

describe BundlesController, type: :controller do
  let(:incorrect_id) { 98822512 }
  let(:current_user) { create(:user) }

  context 'when auth filter is off' do
    before :each do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    describe 'GET #index' do
      it 'should render correct json' do
        bundle = create(:bundle, creator: current_user)

        get :index

        expect(response).to be_success
        expect(response).to serialize_array([bundle]).with(BundlesSerializer)
      end
    end

    describe 'GET #show' do
      context 'with correct id' do
        it 'should render correct bundle as json' do
          bundle = create(:bundle, creator: current_user)

          get :show, params: { id: bundle.slug }

          expect(response).to be_success
          expect(response).to serialize_object(bundle).with(BundleSerializer)
        end
      end

      context 'incorrect bundle id' do
        it 'should respond with 404' do
          get :show, params: { id: incorrect_id }

          expect(response).to have_status(:not_found)
          expect(parse_response['errors']).to eq([I18n.t('error_not_found')])
        end
      end
    end

    describe 'POST #create' do
      context 'with correct data' do
        it 'should create bundle' do
          payload = { bundle: { name: 'name', description: 'description' } }

          expect { post :create, params: payload }
            .to change { Bundle.count }.by(1)
        end

        it 'should set collection' do
          collection = create(:collection, creator: current_user)
          payload = { bundle: { name: 'name', collection_id: collection.id } }

          post :create, params: payload

          bundle = Bundle.friendly.find(parse_response['id'])
          expect(bundle.collection_id).to eq(collection.id)
        end

        it 'should render correct bundle as json' do
          payload = { bundle: { name: FFaker::Name.name,
            description: FFaker::Name.name } }

          post :create, params: payload

          bundle = Bundle.friendly.find(parse_response['id'])

          expect(response).to be_success
          expect(response).to serialize_object(bundle).with(BundleSerializer)
        end
      end

      context 'with incorrect data' do
        it 'should render errors json' do
          payload = { bundle: { name: nil } }

          post :create, params: payload

          expect(response).to have_status(:not_acceptable)
          expect(parse_response['errors']).not_to be_empty
        end
      end
    end

    describe 'PUT #update' do
      context 'with correct data' do
        it 'should update bundle' do
          bundle = create(:bundle, creator: current_user)
          payload = { id: bundle.id, bundle: { name: FFaker::Name.name }  }

          put :update, params: payload
          bundle.reload

          expect(bundle.name).to eq(payload[:bundle][:name])
        end

        it 'should regenerate slug after bundle name update' do
          bundle = create(:bundle, creator: current_user)
          old_slug = bundle.slug
          payload = { id: bundle.id, bundle: { name: FFaker::Name.name }  }

          put :update, params: payload
          bundle.reload

          expect(bundle.slug).not_to eq(old_slug)
        end

        it 'should update collection' do
          bundle = create(:bundle, creator: current_user)
          collection = create(:collection, creator: current_user)

          payload = { bundle: { name: 'name', collection_id: collection.id } }
          post :create, params: payload

          bundle = Bundle.friendly.find(parse_response['id'])
          expect(bundle.collection_id).to eq(collection.id)
        end

        it 'should render correct bundle as json' do
          bundle = create(:bundle, creator: current_user)
          payload = { id: bundle.id, bundle: { name: FFaker::Name.name } }

          put :update, params: payload
          bundle.reload

          expect(response).to be_success
          expect(response).to serialize_object(bundle).with(BundleSerializer)
        end
      end

      context 'with incorrect data' do
        it 'should render errors json' do
          bundle = create(:bundle, creator: current_user)
          payload = { id: bundle.id, bundle: { name: nil } }

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

          expect { delete :destroy, params: { id: bundle } }
            .to change { Bundle.count }.by(-1)
        end

        it 'should render success' do
          bundle = create(:bundle, creator: current_user)

          delete :destroy, params: { id: bundle }

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
      on: :index, via: :get }

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
