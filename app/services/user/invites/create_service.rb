class User::Invites::CreateService
  def initialize(params)
    @resource = params[:resource]
    @data = params[:data]
    @inviter = params[:inviter]
  end

  def call
    if @data.present?
      @data.each do |item|
        user = User.find_by(email: item[:email])
        permission = Permission.find_by_id(item[:permission_id])

        invite(user, permission) if can_invite?(user) && permission.present?
      end
      true
    end
  end

private

  def invite(user, permission)
    invite = @resource.invite({
      inviter: @inviter,
      invited: user,
      permission: permission
    })

    send_mail(invite) if invite.present?
  end

  def send_mail(invite)
    InviteMailer.invite(invite).deliver_now
  end

  def can_invite?(user)
    user.present? && not_invited_or_not_shared_with?(user)
  end

  def not_invited_or_not_shared_with?(user)
    @resource.not_invited?(user) && @resource.not_shared_with?(user)
  end
end
