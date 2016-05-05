require 'spec_helper'

shared_examples_for 'invitable' do
  let(:inviter) { create(:user) }
  let(:invited_user) { create(:user) }
  let(:payload) { { inviter: inviter, invited: invited_user } }
  let(:invitable) { create(described_class) }

  describe '.invite' do
    it 'should create new invite' do
      expect { invitable.invite(payload) }
        .to change { invitable.invites.count }.by(1)
    end

    it 'should return created invite object' do
      invite = invitable.invite(payload)

      expect(invite).to be_kind_of(Invite)
    end

    it 'should have correct inviter user' do
      invite = invitable.invite(payload)

      expect(invite.inviter).to eq(inviter)
    end

    it 'should have correct invited user' do
      invite = invitable.invite(payload)

      expect(invite.invited).to eq(invited_user)
    end
  end

  describe '.invited?' do
    context 'when user is invited' do
      it 'should return true' do
        invitable.invite(payload)

        expect(invitable.invited?(invited_user)).to be_truthy
      end
    end

    context 'when user is not invited' do
      it 'should return false' do
        expect(invitable.invited?(invited_user)).to be_falsy
      end
    end
  end

  describe '.not_invited?' do
    context 'when user is invited' do
      it 'should return false' do
        invitable.invite(payload)

        expect(invitable.not_invited?(invited_user)).to be_falsy
      end
    end

    context 'when user is not invited' do
      it 'should return true' do
        expect(invitable.not_invited?(invited_user)).to be_truthy
      end
    end
  end

  describe '.find_invite_for' do
    context 'when user is invited' do
      it 'should return invite object' do
        invitable.invite(payload)

        expect(invitable.find_invite_for(invited_user)).to be_kind_of(Invite)
      end

      it 'should return correct invite' do
        invite = invitable.invite(payload)

        expect(invitable.find_invite_for(invited_user)).to eq(invite)
      end
    end

    context 'when user is not invited' do
      it 'should return nil' do
        expect(invitable.find_invite_for(invited_user)).to be_nil
      end
    end
  end

  describe '.not_invited?' do
    context 'when user is invited' do
      it 'should return false' do
        invitable.invite(payload)

        expect(invitable.not_invited?(invited_user)).to be_falsy
      end
    end

    context 'when user is not invited' do
      it 'should return true' do
        expect(invitable.not_invited?(invited_user)).to be_truthy
      end
    end
  end
end
