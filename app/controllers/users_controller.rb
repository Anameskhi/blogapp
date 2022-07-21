class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = Post.all.order(created_at: :desc)
    if current_user.id != @user.id
      @user.update(views: @user.views + 1)
    end
  end
  
end