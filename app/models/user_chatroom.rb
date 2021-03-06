class UserChatroom < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  # cannot have same user twice for the same chatroom
  validates :user, uniqueness: { scope: :chatroom, message: "is already in the chatroom" }

  # if private, max of 2 participants
  validate :max_two_participants, if: :chatroom_is_private?
  # validate :private_chat_uniqueness
  # VALIDATION HELPER METHODS
  def max_two_participants
    # chatroom.user_chatrooms.select(&:persisted?).size >= 2
    errors.add(:chatroom, "already has two participants") if chatroom.user_chatrooms.pluck(:id).size >= 2
  end

  def chatroom_is_private?
    chatroom.private?
  end

  def private_chat_uniqueness
    other_user = chatroom.users.where.not(id: user_id).take
    existing_private_chatroom_ids = user.chatrooms.private_chats.pluck(:id)
    existing_user_chatroom = UserChatroom.where.not(chatroom_id: chatroom.id).where(chatroom_id: existing_private_chatroom_ids, user: other_user)

    errors.add(:chatroom, "for these two users already exists") if existing_user_chatroom.present?
  end
end
