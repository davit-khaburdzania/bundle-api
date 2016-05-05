class User::Invites::ApproveService
  def initialize(params)
    @resource = params[:resource]
    @invited_user = params[:invited_user]
  end

  def call
    if can_be_approved?
      sharing_result = share_resource
      @invite.destroy if sharing_result
      sharing_result
    end
  end

private

  def can_be_approved?
    @invite = @resource.find_invite_for(@invited_user)
    @invite.present?
  end

  def share_resource
    share = @resource.share_with({
      user: @invited_user,
      permission: @invite.permission
    })

    share.present?
  end
end
