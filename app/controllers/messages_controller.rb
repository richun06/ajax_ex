class MessagesController < ApplicationController
  # メッセージの機能の場合、いずれのアクションも「どの会話（チャットルーム）に存在するメッセージなのか？」という情報が必要不可欠のため、
  # 「どの会話（チャットルーム）でなされているメッセージなのか？」を取得する処理を各アクションではなく共通の処理としてコントローラに定義する
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
end
