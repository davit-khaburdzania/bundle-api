require 'rails_helper'

describe User::Invites::ApproveService do
  let(:inviter) { create(:user) }
  let(:invited_user1) { create(:user) }
  let(:invited_user2) { create(:user) }
  let(:bundle) { create(:bundle) }
  let(:collection) { create(:collection) }

  context 'when resource is Collection' do
    context 'with valid data' do
      let(:service) {
        service_instance({ resource: collection, invited_user: invited_user1 })
      }

      context 'when invite exists' do
        before(:each) do
          collection.invite({ inviter: inviter, invited: invited_user1 })
        end

        it 'should delete invite' do
          expect { service.call }.to change { collection.invites.count }.by(-1)
        end

        it 'should share resource' do
          expect { service.call }.to change { collection.shares.count }.by(1)
        end

        it 'should return true' do
          expect(service.call).to be_truthy
        end
      end

      context 'when invite doesnt exist' do
        it 'should not delete invite' do
          expect { service.call }.not_to change { collection.invites.count }
        end

        it 'should not share resource' do
          expect { service.call }.not_to change { collection.shares.count }
        end

        it 'should return nil' do
          expect(service.call).to be_nil
        end
      end
    end
  end

  context 'when resource is Bundle' do
    let(:service) {
      service_instance({ resource: bundle, invited_user: invited_user1 })
    }

    context 'with valid data' do
      context 'when invite exists' do
        before(:each) do
          bundle.invite({ inviter: inviter, invited: invited_user1 })
        end

        it 'should delete invite' do
          expect { service.call }.to change { bundle.invites.count }.by(-1)
        end

        it 'should share resource' do
          expect { service.call }.to change { bundle.shares.count }.by(1)
        end

        it 'should return true' do
          expect(service.call).to be_truthy
        end
      end

      context 'when invite doesnt exist' do
        it 'should not delete invite' do
          expect { service.call }.not_to change { bundle.invites.count }
        end

        it 'should not share resource' do
          expect { service.call }.not_to change { bundle.shares.count }
        end

        it 'should return nil' do
          expect(service.call).to be_nil
        end
      end
    end
  end

  context 'with invalid data' do
    let(:service) { service_instance({ resource: collection }) }

    before(:each) do
      collection.invite({ inviter: inviter, invited: invited_user1 })
    end

    it 'should not delete invite' do
      expect { service.call }.not_to change { collection.invites.count }
    end

    it 'should return nil' do
      expect(service.call).to be_nil
    end
  end

private

  def service_instance(payload)
    described_class.new(payload)
  end
end
