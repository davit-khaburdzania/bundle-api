class InviteMailer < ApplicationMailer
  def invite(invite)
    @resource = invite.invitable
    @inviter = invite.inviter
    @invited = invite.invited

    mail(
      to: @invited.email,
      subject: "Invitation To #{@resource.class.name}"
    )
  end
end
