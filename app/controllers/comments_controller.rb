class CommentsController < ApplicationController
  before_action :set_blog, only: [:create, :edit, :update]

  # コメントを保存、投稿するためのアクション
  def create
    # @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.build(comment_params) # Blogをパラメータの値から探し出し、Blogに紐づくcommentsとしてbuildする
    # @blog.comments.build(comment_params)という記述をすることで、@blogのidをblog_idにあらかじめ含んだ状態のCommentインスタンスをnew（作成）することができる

    @comment.user_id = current_user.id
    # byebug
    respond_to do |format|
      if @comment.save
        # format.html { redirect_to blog_path(@blog) }
        flash.now[:notice] = 'コメントが投稿されました'
        format.js { render :index }
      else
        format.html { redirect_to blog_path(@blog), notice: '投稿できませんでした...' }
      end
    end
  end

  def edit
    @comment = @blog.comments.find(params[:id])
    if @comment.user == current_user
      respond_to do |format|
        flash.now[:notice] = 'コメントの編集中'
        format.js { render :edit }
      end
    else
      redirect_to blogs_path
    end
  end

  def update
    @comment = @blog.comments.find(params[:id])
      respond_to do |format|
        if @comment.update(comment_params)
          flash.now[:notice] = 'コメントが編集されました'
          format.js { render :index }
        else
          flash.now[:notice] = 'コメントの編集に失敗しました'
          format.js { render :edit }
        end
      end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      respond_to do |format|
        flash.now[:notice] = 'コメントが削除されました'
        format.js { render :index }
      end
    else
      redirect_to blog_path(@blog)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end
end
