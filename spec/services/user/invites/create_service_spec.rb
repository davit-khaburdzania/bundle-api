require 'rails_helper'

describe User::Invites::CreateService do
  let(:inviter) { create(:user) }
  let(:invited_user1) { create(:user) }
  let(:invited_user2) { create(:user) }
  let(:permission1) { create(:permission) }
  let(:permission2) { create(:permission) }
  let(:bundle) { create(:bundle) }
  let(:collection) { create(:collection) }

  context 'when resource is Bundle' do
    context 'with valid data' do
      it 'should create new invites' do
        service = service_instance(bundle_payload)

        expect { service.call }
          .to change { bundle.invites.count }.by(invite_data.count)
      end

      it 'should send invitation email' do
        service = service_instance(bundle_payload)

        expect { service.call }.to change {
          ActionMailer::Base.deliveries.count
        }.by(invite_data.count)
      end

      it 'should return true' do
        service = service_instance(bundle_payload)

        expect(service.call).to be_truthy
      end
    end

    context 'with incorrect data' do
      it 'should not create new invites' do
        service = service_instance(incorrect_bundle_payload)

        expect { service.call }.not_to change { bundle.invites.count }
      end

      it 'should not send invitation email' do
        service = service_instance(incorrect_bundle_payload)

        expect { service.call }.not_to change {
          ActionMailer::Base.deliveries.count
        }
      end

      it 'should return nil' do
        service = service_instance(incorrect_bundle_payload)

        expect(service.call).to be_nil
      end
    end
  end

  context 'when resource is Collection' do
    context 'with valid data' do
      it 'should create new invites' do
        service = service_instance(collection_payload)

        expect { service.call }
          .to change { collection.invites.count }.by(invite_data.count)
      end

      it 'should send invitation email' do
        service = service_instance(bundle_payload)

        expect { service.call }.to change {
          ActionMailer::Base.deliveries.count
        }.by(invite_data.count)
      end

      it 'should return true' do
        service = service_instance(collection_payload)

        expect(service.call).to be_truthy
      end
    end

    context 'with incorrect data' do
      it 'should not create new invites' do
        service = service_instance(incorrect_collection_payload)

        expect { service.call }.not_to change { collection.invites.count }
      end

      it 'should not send invitation email' do
        service = service_instance(incorrect_collection_payload)

        expect { service.call }.not_to change {
          ActionMailer::Base.deliveries.count
        }
      end

      it 'should return nil' do
        service = service_instance(incorrect_collection_payload)

        expect(service.call).to be_nil
      end
    end
  end

private

  def invite_data
    [
      { email: invited_user1.email, permission_id: permission1.id },
      { email: invited_user2.email, permission_id: permission2.id }
    ]
  end

  def service_instance(payload)
    described_class.new(payload)
  end

  def bundle_payload
    { inviter: inviter, data: invite_data, resource: bundle }
  end

  def collection_payload
    { inviter: inviter, data: invite_data, resource: collection }
  end

  def incorrect_bundle_payload
    { inviter: inviter, resource: bundle }
  end

  def incorrect_collection_payload
    { inviter: inviter, resource: collection }
  end
end
