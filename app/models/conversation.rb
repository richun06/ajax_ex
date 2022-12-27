class Conversation < ApplicationRecord
  # 会話はUserの概念をsenderとrecipientに分けた形でアソシエーションする
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User' # 会話の送り手がユーザモデルから参照できるようにアソシエーションを設定
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User' # 会話の受け手がユーザモデルから参照できるようにアソシエーションを設定
  # 一つの会話はメッセージをたくさん含む一対多
  has_many :messages, dependent: :destroy # 会話は複数のメッセージを保有し、会話が削除されたらメッセージも削除する

  # [:sender_id, :recipient_id]が同じ組み合わせで保存されないようにするためのバリデーションを設定 (validates_uniqueness_of は、属性の値が一意であることを検証するメソッド)
  validates_uniqueness_of :sender_id, scope: :recipient_id
  # これをしておかないと、同じ組み合わせで保存に失敗した時にDB側でのエラーが発生する
  # バリデーション設定をしておくことで、DBのエラーとなる前にアプリケーション側でエラーを検知し、ユーザーに間違いを知らせることができる

  # 送り手と受け手の「組み合わせ」で判定するbetweenスコープを定義する 過去に会話が存在していたかどうかを確認するもの
  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND  conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end

  # このメソッドを起動させた際のcurrent_userと、current_userの相手となるuserの情報を取得する
  def target_user(current_user)
    if sender_id == current_user.id
      User.find(recipient_id)
    elsif recipient_id == current_user.id
      User.find(sender_id)
    end
  end
end

# == Schema Information
#
# Table name: conversations
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#
# Indexes
#
#  index_conversations_on_recipient_id                (recipient_id)
#  index_conversations_on_sender_id                   (sender_id)
#  index_conversations_on_sender_id_and_recipient_id  (sender_id,recipient_id) UNIQUE
#
