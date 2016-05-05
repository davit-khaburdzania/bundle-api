require 'spec_helper'

shared_examples_for 'sharable' do
  let(:current_user) { create(:user) }
  let(:shared_user) { create(:user) }
  let(:permission) { create(:permission) }
  let(:payload) { { user: shared_user, permission: permission } }
  let(:sharable) { create(described_class) }

  describe '.share_with' do
    it 'should create new share' do
      expect { sharable.share_with(payload) }
        .to change { sharable.shares.count }.by(1)
    end

    it 'should return created share object' do
      share = sharable.share_with(payload)

      expect(share).to be_kind_of(Share)
    end

    it 'should have correct user' do
      share = sharable.share_with(payload)

      expect(share.user).to eq(shared_user)
    end
  end

  describe '.shared_with?' do
    context 'when resource is shared with user' do
      it 'should return true' do
        sharable.share_with(payload)

        expect(sharable.shared_with?(shared_user)).to be_truthy
      end
    end

    context 'when resource is not shared with user' do
      it 'should return false' do
        expect(sharable.shared_with?(shared_user)).to be_falsy
      end
    end
  end

  describe '.not_shared_with?' do
    context 'when resource is shared with user' do
      it 'should return false' do
        sharable.share_with(payload)

        expect(sharable.not_shared_with?(shared_user)).to be_falsy
      end
    end

    context 'when resource is not shared with user' do
      it 'should return true' do
        expect(sharable.not_shared_with?(shared_user)).to be_truthy
      end
    end
  end

  describe '.share_by_url!' do
    context 'when resource is not shared by url' do
      it 'should create url share' do
        sharable.share_by_url!(url_share_payload)

        expect(sharable.url_share).not_to be_nil
      end

      it 'should belong to correct user' do
        sharable.share_by_url!(url_share_payload)

        expect(sharable.url_share.user).to eq(current_user)
      end

      it 'should return url share object' do
        sharable.share_by_url!(url_share_payload)

        expect(sharable.url_share).to be_kind_of(UrlShare)
      end
    end

    context 'when resource is shared by url' do
      it 'should not create new url share' do
        sharable.share_by_url!(url_share_payload)

        expect(sharable.share_by_url!(current_user)).to be_nil
      end
    end
  end

  describe '.shared_by_url?' do
    context 'when resource is not shared by url' do
      it 'should return false' do
        expect(sharable.shared_by_url?).to be_falsy
      end
    end

    context 'when resource is shared by url' do
      it 'should return true' do
        sharable.share_by_url!(current_user)

        expect(sharable.shared_by_url?).to be_truthy
      end
    end
  end

  describe '.not_shared_by_url?' do
    context 'when resource is not shared by url' do
      it 'should return false' do
        expect(sharable.not_shared_by_url?).to be_truthy
      end
    end

    context 'when resource is shared by url' do
      it 'should return true' do
        sharable.share_by_url!(current_user)

        expect(sharable.not_shared_by_url?).to be_falsy
      end
    end
  end

private

  def url_share_payload
    { user: current_user, permission: permission }
  end
end
