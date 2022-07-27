# frozen_string_literal: true

class AdminController < ApplicationController
  def index; end

  def posts
    @pagy, @posts = pagy(Post.all.includes(:user, :comments), items: 10)
  end

  def comments; end

  def users
    @pagy, @users = pagy(User.all, items: 10)
   
  end
  def show_user
   @user = User.find(params[:id])
   @pagy, @posts = pagy(@user.posts, items: 10)
   
  end
  
  
  def admin_delete_user
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_users_path

  end
 
  def show_post
    @post = Post.includes(:user, :comments).find(params[:id])
  end
end
