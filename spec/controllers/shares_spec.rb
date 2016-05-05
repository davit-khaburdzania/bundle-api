require 'rails_helper'

describe SharesController, type: :controller do
  let(:current_user) { create(:user) }
  let(:collection) { create(:collection) }
  let(:bundle) { create(:bundle) }
  let(:permission) { create(:permission) }

  before :each do
    allow(controller).to receive(:authenticate!).and_return(true)
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe 'POST #share_by_url' do
    context 'with correct data' do
      it 'should share bundle by url' do
        expect_any_instance_of(Bundle).to receive(:share_by_url!)

        post :share_by_url, params: bundle_payload
      end

      it 'should return success' do
        post :share_by_url, params: bundle_payload

        expect(response).to have_status(:success)
      end

      it 'should return json with share url data' do
        post :share_by_url, params: bundle_payload

        url_share = UrlShare.find(parse_response['id'])

        expect(response).to serialize_object(url_share).with(UrlShareSerializer)
      end
    end

    context 'with incorrect data' do
      it 'should not share bundle by url' do
        expect_any_instance_of(Bundle).not_to receive(:share_by_url!)

        post :share_by_url, params: incorrect_payload
      end

      it 'should return error' do
        post :share_by_url, params: incorrect_payload

        expect(response).to have_status(:unprocessable_entity)
        expect(parse_response['errors']).not_to be_nil
      end
    end
  end

  context 'filters' do
    it { is_expected.to execute_before_action :authenticate!,
      on: :share_by_url, via: :post, with: collection_payload }

    it { is_expected.to execute_before_action :set_resource,
      on: :share_by_url, via: :post, with: collection_payload }
  end

private

  def parse_response
    JSON.parse(response.body)
  end

  def collection_payload
    { resource: 'collections', id: collection.id, permission_id: permission.id }
  end

  def bundle_payload
    { resource: 'bundles', id: bundle.id, permission_id: permission.id }
  end

  def incorrect_payload
    { resource: 'incorrect', id: 12313 }
  end
end
