class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  respond_to? :js # 存在するアクションのrespondを全てjsで返す場合はこのような記述でも可能

  def create
    # 自身で作ったログイン機能であれば、独自実装してあるはずのlogged_in?メソッドを使用して、ログイン時のみフォローできるようにする
    # if logged_in?
    #   @user = User.find(params[:relationship][:followed_id])
    #   current_user.follow!(@user)
    # end

    # フォローしたいユーザを取得
    @user = User.find(params[:relationship][:followed_id])
    # そのユーザをフォローする
    current_user.follow!(@user)
  end

  def destroy
  end
end
