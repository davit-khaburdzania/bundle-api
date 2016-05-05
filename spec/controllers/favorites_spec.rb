require 'rails_helper'

describe FavoritesController, type: :controller do
  let(:current_user) { create(:user) }
  let(:collection) { create(:collection) }
  let(:bundle) { create(:bundle) }
  let(:collection_payload) { { resource: 'collections', id: collection.id } }
  let(:bundle_payload) { { resource: 'bundles', id: bundle.id } }
  let(:incorrect_payload) { { resource: 'incorrect', id: 1 } }

  context 'when auth filter is off' do
    before :each do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    describe 'GET #index' do
      it 'should render favorites as json' do
        # favorite = create(:favorite, favoritable: collection)
        #
        # get :index
        #
        # expect(response).to be_success
        # expect(response).to serialize_array([favorite]).with(FavoritesSerializer)
      end
    end

    describe 'POST #favorite' do
      context 'when resource is Collection' do
        context 'when user not favorited' do
          it 'should create favorite' do
            expect {
              post :favorite, params: collection_payload
            }.to change { collection.favorites.count }.by(1)
          end

          it 'should increment favorites_count by 1' do
            expect {
              post :favorite, params: collection_payload
              collection.reload
            }.to change { collection.favorites_count }.by(1)
          end

          skip 'should render correct collection as json' do
            post :favorite, params: collection_payload

            collection.reload

            expect(response).to be_success
            expect(response).to serialize_object(collection).with(CollectionSerializer)
          end
        end

        context 'when user already favorited' do
          before(:each) do
            collection.favorite_by(current_user)
          end

          it 'should not create favorite' do
            expect { post :favorite, params: collection_payload }
              .not_to change { collection.favorites.count }
          end

          it 'should not increment favorites_count by 1' do
            expect {
              post :favorite, params: collection_payload
              collection.reload
            }.not_to change { collection.favorites_count }
          end
        end
      end

      context 'when resource is Bundle' do
        context 'when user not favorited' do
          it 'should create favorite' do
            expect { post :favorite, params: bundle_payload }
              .to change { bundle.favorites.count }.by(1)
          end

          it 'should increment favorites_count by 1' do
            expect {
              post :favorite, params: bundle_payload
              bundle.reload
            }.to change { bundle.favorites_count }.by(1)
          end

          skip 'should render correct bundle as json' do
            post :favorite, params: bundle_payload

            bundle.reload

            expect(response).to be_success
            expect(response).to serialize_object(bundle).with(BundleSerializer)
          end
        end

        context 'when user already favorited' do
          before(:each) do
            bundle.favorite_by(current_user)
          end

          it 'should not create favorite' do
            expect { post :favorite, params: bundle_payload }
              .not_to change { bundle.favorites.count }
          end

          it 'should not increment favorites_count by 1' do
            expect {
              post :favorite, params: bundle_payload
              bundle.reload
            }.not_to change { bundle.favorites_count }
          end
        end
      end

      context 'when resource is incorrect' do
        it 'should render errors json' do
          post :favorite, params: incorrect_payload

          expect(response).to have_status(:unprocessable_entity)
          expect(parse_response['errors']).not_to be_empty
        end
      end
    end

    describe 'DELETE #unfavorite' do
      context 'when resource is Collection' do
        context 'when user not favorited' do
          it 'should not delete favorite' do
            expect { delete :unfavorite, { params: collection_payload } }
              .not_to change { collection.favorites.count }
          end

          it 'should not decrement favorites_count by 1' do
            expect {
              delete :unfavorite, params: collection_payload
              collection.reload
            }.not_to change { collection.favorites_count }
          end
        end

        context 'when user already favorited' do
          it 'should delete favorite' do
            collection.favorite_by(current_user)

            expect { delete :unfavorite, params: collection_payload }
              .to change { collection.favorites.count }.by(-1)
          end

          it 'should decrement favorites_count by 1' do
            collection.favorite_by(current_user)

            expect {
              delete :unfavorite, params: collection_payload
              collection.reload
            }.to change { collection.favorites_count }.by(-1)
          end
        end
      end

      context 'when resource is Bundle' do
        context 'when user not favorited' do
          it 'should not delete favorite' do
            expect { delete :unfavorite, params: bundle_payload }
              .not_to change { bundle.favorites.count }
          end

          it 'should not decrement favorites_count by 1' do
            expect {
              delete :unfavorite, params: bundle_payload
              bundle.reload
            }.not_to change { bundle.favorites_count }
          end
        end

        context 'when user already favorited' do
          it 'should delete favorite' do
            bundle.favorite_by(current_user)

            expect { delete :unfavorite, params: bundle_payload }
              .to change { bundle.favorites.count }.by(-1)
          end

          it 'should decrement favorites_count by 1' do
            bundle.favorite_by(current_user)

            expect {
              delete :unfavorite, params: bundle_payload
              bundle.reload
            }.to change { bundle.favorites_count }.by(-1)
          end
        end
      end

      context 'when resource is incorrect' do
        it 'should render errors json' do
          post :favorite, params: incorrect_payload

          expect(response).to have_status(:unprocessable_entity)
          expect(parse_response['errors']).not_to be_empty
        end
      end
    end
  end

  context 'when auth filter is on' do
    data = { resource: 'dumb', id: 1 }

    it { is_expected.to execute_before_action :authenticate!,
      on: :favorite, via: :post, with: data }

    it { is_expected.to execute_before_action :authenticate!,
      on: :unfavorite, via: :delete, with: data }
  end

private

  def parse_response
    JSON.parse(response.body)
  end
end
