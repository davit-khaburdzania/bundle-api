require 'rails_helper'

describe InvitesController, type: :controller do
  let(:current_user) { create(:user) }
  let(:inviter) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:collection) { create(:collection) }
  let(:collection2) { create(:collection) }
  let(:bundle) { create(:bundle) }
  let(:bundle2) { create(:bundle) }
  let(:permission) { create(:permission) }

  before :each do
    allow(controller).to receive(:authenticate!).and_return(true)
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe 'POST #invite' do
    context 'when resource is Collection' do
      it 'should create invites' do
        expect {
          post :create, { params: collection_payload }
          collection.reload
        }.to change { collection.invites.count }.by(invite_data.count)
      end

      it 'should respond with success' do
        post :create, { params: collection_payload }

        expect(response).to be_success
        expect(parse_response['success']).to be_truthy
      end
    end

    context 'when resource is Bundle' do
      it 'should create invites' do
        expect {
          post :create, { params: bundle_payload }
          bundle.reload
        }.to change { bundle.invites.count }.by(invite_data.count)
      end

      it 'should respond with success' do
        post :create, { params: bundle_payload }

        expect(response).to be_success
        expect(parse_response['success']).to be_truthy
      end
    end

    context 'with incorrect data' do
      it 'should not create invites' do
        expect {
          post :create, { params: incorrect_email_payload }
          collection.reload
        }.not_to change { collection.invites.count }
      end

      it 'should respond with error' do
        post :create, { params: incorrect_email_payload }

        expect(response).to have_status(:not_acceptable)
        expect(parse_response['errors']).to eq([I18n.t('couldnt_invite')])
      end
    end

    context 'when resource is incorrect' do
      it 'should render errors json' do
        post :create, params: incorrect_resource_payload

        expect(response).to have_status(:unprocessable_entity)
        expect(parse_response['errors']).not_to be_empty
      end
    end
  end

  describe 'POST #approve' do
    context 'when resource is Collection' do
      let(:correct_payload) { { resource: 'collections', id: collection.id } }
      let(:incorrect_payload) { { resource: 'collections', id: collection2.id } }

      context 'if invite exists' do
        before(:each) do
          collection.invite({ inviter: inviter, invited: current_user })
        end

        context 'with correct data' do
          it 'should delete invite' do
            expect { post :approve, params: correct_payload }
              .to change { collection.invites.count }.by(-1)
          end

          it 'should respond with success' do
            post :approve, params: correct_payload

            expect(response).to be_success
            expect(parse_response['success']).to be_truthy
          end
        end

        context 'with incorrect data' do
          it 'should not delete invite' do
            expect { post :approve, params: incorrect_payload }
              .not_to change { collection.invites.count }
          end

          it 'should respond with error' do
            post :approve, params: incorrect_payload

            expect(response).to have_status(:not_acceptable)
            expect(parse_response['errors'])
              .to eq([I18n.t('couldnt_approve_invite')])
          end
        end
      end

      context 'if invite doesnt exists' do
        it 'should not delete invite' do
          expect { post :approve, params: correct_payload }
            .not_to change { collection.invites.count }
        end

        it 'should respond with error' do
          post :approve, params: correct_payload

          expect(response).to have_status(:not_acceptable)
          expect(parse_response['errors'])
            .to eq([I18n.t('couldnt_approve_invite')])
        end
      end
    end

    context 'when resource is Bundle' do
      let(:correct_payload) { { resource: 'bundle', id: bundle.id } }
      let(:incorrect_payload) { { resource: 'bundle', id: bundle2.id } }

      context 'if invite exists' do
        before(:each) do
          bundle.invite({ inviter: inviter, invited: current_user })
        end

        context 'with correct data' do
          it 'should delete invite' do
            expect { post :approve, params: correct_payload }
              .to change { bundle.invites.count }.by(-1)
          end

          it 'should respond with success' do
            post :approve, params: correct_payload

            expect(response).to be_success
            expect(parse_response['success']).to be_truthy
          end
        end

        context 'with incorrect data' do
          it 'should not delete invite' do
            expect { post :approve, params: incorrect_payload }
              .not_to change { collection.invites.count }
          end

          it 'should respond with error' do
            post :approve, params: incorrect_payload

            expect(response).to have_status(:not_acceptable)
            expect(parse_response['errors'])
              .to eq([I18n.t('couldnt_approve_invite')])
          end
        end
      end

      context 'if invite doesnt exists' do
        it 'should not delete invite' do
          expect { post :approve, params: correct_payload }
            .not_to change { bundle.invites.count }
        end

        it 'should respond with error' do
          post :approve, params: correct_payload

          expect(response).to have_status(:not_acceptable)
          expect(parse_response['errors'])
            .to eq([I18n.t('couldnt_approve_invite')])
        end
      end
    end
  end

  context 'filters' do
    it { is_expected.to execute_before_action :authenticate!,
      on: :create, via: :post, with: bundle_payload }

    it { is_expected.to execute_before_action :authenticate!,
      on: :approve, via: :post, with: bundle_payload }

    it { is_expected.to execute_before_action :set_resource,
      on: :create, via: :post, with: bundle_payload }

    it { is_expected.to execute_before_action :set_resource,
      on: :approve, via: :post, with: bundle_payload }
  end

private

  def parse_response
    JSON.parse(response.body)
  end

  def collection_payload
    { resource: 'collections', id: collection.id, data: invite_data }
  end

  def bundle_payload
    { resource: 'bundles', id: bundle.id, data: invite_data }
  end

  def incorrect_email_payload
    { resource: 'bundles', id: bundle.id }
  end

  def incorrect_resource_payload
    { resource: 'incorrect', id: 1 }
  end

  def invite_data
    [{ email: invited_user.email, permission_id: permission.id }]
  end
end
