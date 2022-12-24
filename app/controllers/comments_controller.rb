class CommentsController < ApplicationController

  # コメントを保存、投稿するためのアクション
  def create
    @blog = Blog.find(params[:blog_id])
    @comment = @blog.comments.build(comment_params) # Blogをパラメータの値から探し出し、Blogに紐づくcommentsとしてbuildする
    # @blog.comments.build(comment_params)という記述をすることで、@blogのidをblog_idにあらかじめ含んだ状態のCommentインスタンスをnew（作成）することができる

    # byebug
    respond_to do |format|
      if @comment.save
        # format.html { redirect_to blog_path(@blog) }
        format.js { render :index }
      else
        format.html { redirect_to blog_path(@blog), notice: '投稿できませんでした...' }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
