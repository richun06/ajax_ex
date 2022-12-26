class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = Conversation.all
  end

  # senderが送り主で、recipientが受取人
  def create
    # 該当のユーザ間での会話が過去に存在しているか（該当ユーザー間で会話をするためのチャットルームがすでに存在しているか）を確認する式
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      # 存在していたら、その会話（チャットルーム）情報を取得する
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id]).first
    else # もし、過去に一件も存在しなかった場合、
      # 強制的に会話（チャットルーム）情報を生成する
      @conversation = Conversation.create!(conversation_params)
    end
    # いずれの状態であってもその後その会話に紐づくメッセージの一覧画面へ遷移させる
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end
