class AdminController < ApplicationController
  def index
  end

  def posts
    @pagy,@posts = pagy(Post.all.includes(:user, :comments), items: 15)
  end

  def comments
  end

  def users
    @users = User.all
  end


  def show_post
    @post = Post.includes(:user, :comments).find(params[:id])
  end
end
