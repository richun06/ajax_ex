class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  # メッセージの内容やひもづく会話、ユーザのIDが値が空でないかをチェックする
  validates_presence_of :body, :conversation_id, :user_id

  # 画面上に表示させる作成日は時刻をフォーマットに従って表示する処理
  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end
end

# == Schema Information
#
# Table name: messages
#
#  id              :bigint           not null, primary key
#  body            :text
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  conversation_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#  fk_rails_...  (user_id => users.id)
#
