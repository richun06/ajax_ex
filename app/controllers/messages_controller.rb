class MessagesController < ApplicationController
  # メッセージの機能の場合、いずれのアクションも「どの会話（チャットルーム）に存在するメッセージなのか？」という情報が必要不可欠のため、
  # 「どの会話（チャットルーム）でなされているメッセージなのか？」を取得する処理を各アクションではなく共通の処理としてコントローラに定義する
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  # 会話のページに移行した際に表示されるメッセージ一覧と新規のメッセージ投稿画面を表示することができる
  def index
    # 会話にひもづくメッセージを取得する
    @messages = @conversation.messages

    # もしメッセージの数が10よりも大きければ、10より大きいというフラグを有効にしてメッセージを最新の10に絞ることをする
    if @messages.length > 10
      @over_ten = true
      # 直近で登録されたメッセージの10件のidを取得し、そのidのmessageの配列をwhereメソッドで取得する
      @messages = Message.where(id: @messages[-10..-1].pluck(:id))
    end

    # そうでなければ10より大きいというフラグを無効にして、会話にひもづくメッセージをすべて取得する
    if params[:m] # params[:m]というのは、link_toにオプションで追記するクエリパラメータ
    # params[:m]というパラメータをチェックした時、そこに値があれば（trueであれば）その下の二行を実行する
      @over_ten = false
      @messages = @conversation.messages
    end

    # もし最新（最後）のメッセージが存在し、かつユーザIDが自分（ログインユーザ）でなければ、今映っているメッセージを全て既読にする (lastメソッドは、配列の最後の要素を返し空のときはnilを返す、というRubyのメソッド)
    if @messages.last
      @messages.where.not(user_id: current_user.id).update_all(read: true)
    end

    # 表示するメッセージを作成日時順（投稿された順）に並び替える
    @messages = @messages.order(:created_at)
    # 新規投稿のメッセージ用の変数を作成する (buildはnewとほぼ同じ内容の処理をするが、慣習的に「すでにアソシエーションしてあるインスタンスの生成」ということを表す)
    @message = @conversation.messages.build
    # (「これはピカピカの状態のインスタンスではなく、すでにアソシエーションで他のものと紐づけられているインスタンスである」ということを表したい記述の場合は、newではなくbuildがよく使われ)
  end

  def create
    # 送られてきたparamsの値を利用して会話にひもづくメッセージを生成
    @message = @conversation.messages.build(message_params)
    if @message.save # 保存ができれば、会話にひもづくメッセージ一覧の画面（つまりチャットルーム）に遷移する
      redirect_to conversation_messages_path(@conversation)
    else
      render 'index'
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end
