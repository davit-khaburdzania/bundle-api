class Invite < ApplicationRecord
  belongs_to :invitable, polymorphic: true
  belongs_to :inviter, class_name: 'User'
  belongs_to :invited, class_name: 'User'
  belongs_to :permission

  #GIOGIO Fix this
  # validates_presence_of :inviter, :invited, :invitable, :permission
end
