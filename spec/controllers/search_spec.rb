require 'rails_helper'

describe SearchController, type: :controller do
  let(:incorrect_id) { 98822512 }
  let(:current_user) { create(:user) }

  context 'when auth filter is off' do
    before :each do
      allow(controller).to receive(:authenticate!).and_return(true)
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    describe 'GET #resource' do
      context 'with correct query' do
        payload = { q: 'test' }

        it 'should create SearchResource object' do
          create(:bundle, name: 'x test x', creator: current_user)
          create(:collection, name: 'test x', creator: current_user)

          search_result = SearchResource.new(user: current_user, query: payload[:q]).search
          serializer = SearchResourceSerializer

          get :resource, params: payload

          expect(response).to serialize_object(search_result).with(serializer)
        end

        it 'should respond ok' do
          get :resource, params: payload
          expect(response).to be_success
        end
      end
    end
  end

  context 'when auth filter is on' do
    it { is_expected.to execute_before_action :authenticate!,
      on: :resource, via: :get }
  end
end
