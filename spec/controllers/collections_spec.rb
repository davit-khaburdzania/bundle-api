require 'rails_helper'

describe CollectionsController, type: :controller do
  let(:current_user) { create(:user) }
  let(:incorrect_id) { 98822112 }

  context 'when auth filter is off' do
    before :each do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    describe 'GET #index' do
      it 'should render correct json' do
        collection = create(:collection, creator: current_user)

        get :index

        expect(response).to be_success
        expect(response).to serialize_array([collection]).with(CollectionsSerializer)
      end
    end

    describe 'GET #show' do
      context 'with correct id' do
        it 'should render correct collection as json' do
          collection = create(:collection, creator: current_user)

          get :show, params: { id: collection.slug }

          expect(response).to serialize_object(collection).with(CollectionSerializer)
          expect(response).to be_success
        end
      end

      context 'incorrect collection id' do
        it 'should respond wih 404' do
          get :show, params: { id: incorrect_id }

          expect(response).to have_status(:not_found)
          expect(parse_response['errors']).to eq([I18n.t('error_not_found')])
        end
      end
    end

    describe 'POST #create' do
      context 'with correct data' do
        it 'should create collection ' do
          payload = { name: FFaker::Name.name }

          expect { post :create, { params: payload } }
            .to change { Collection.count }.by(1)
        end

        it 'should render correct collection as json' do
          payload = { name: FFaker::Name.name }

          post :create, params: payload

          collection = Collection.friendly.find(parse_response['id'])

          expect(response).to be_success
          expect(response).to serialize_object(collection).with(CollectionSerializer)
        end
      end

      context 'with incorrect data' do
        it 'should render errors json' do
          payload = { name: nil }

          post :create, params: payload

          expect(response).to have_status(:not_acceptable)
          expect(parse_response['errors']).not_to be_empty
        end
      end
    end

    describe 'PUT #update' do
      context 'with correct data' do
        it 'should update collection' do
          collection = create(:collection, creator: current_user)
          payload = { name: FFaker::Name.name, id: collection }

          put :update, params: payload
          collection.reload

          expect(collection.name).to eq(payload[:name])
        end

        it 'should regenerate slug after collection name update' do
          collection = create(:collection, creator: current_user)
          old_slug = collection.slug
          payload = { name: FFaker::Name.name, id: collection }

          put :update, params: payload
          collection.reload

          expect(collection.slug).not_to eq(old_slug)
        end

        it 'should render correct collection as json' do
          collection = create(:collection, creator: current_user)
          payload = { name: FFaker::Name.name, id: collection }

          put :update, params: payload

          collection.reload

          expect(response).to be_success
          expect(response).to serialize_object(collection).with(CollectionSerializer)
        end
      end

      context 'with incorrect data' do
        it 'should render errors json' do
          collection = create(:collection, creator: current_user)
          payload = { name: nil, id: collection }

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
      context 'with correct collection id' do
        it 'should destroy collection' do
          collection = create(:collection, creator: current_user)

          expect { delete :destroy, params: { id: collection } }
            .to change { Collection.count }.by(-1)
        end

        it 'should render success' do
          collection = create(:collection, creator: current_user)

          delete :destroy, params: { id: collection }

          expect(parse_response['success']).to be_truthy
        end
      end

      context 'incorrect collection id' do
        it 'should return 404 and render errors' do
          delete :destroy, params: { id: incorrect_id }

          expect(response).to have_status(:not_found)
          expect(parse_response['errors']).to eq([I18n.t('error_not_found')])
        end
      end
    end

    describe 'GET #bundles' do
      context 'with correct id' do
        it 'should render bundles for that collection as json' do
          collection = create(:collection)
          bundles = create_list(:bundle, 5, creator: current_user, collection: collection)

          get :bundles, params: { id: collection.id }

          expect(response).to serialize_array(collection.bundles).with(BundlesSerializer)
          expect(response).to be_success
        end
      end

      context 'incorrect collection id' do
        it 'should respond wih 404' do
          get :bundles, params: { id: incorrect_id }

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
      on: :bundles, via: :get, with: data }

    it { is_expected.to execute_before_action :authenticate!,
      on: :update, via: :put, with: data }

    it { is_expected.to execute_before_action :authenticate!,
      on: :destroy, via: :delete, with: data }
  end

  def parse_response
    JSON.parse(response.body)
  end

  def user_token
    'qwer1234'
  end
end
