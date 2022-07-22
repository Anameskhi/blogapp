class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @pagy,@posts = pagy(Post.all.order(created_at: :desc), items: 5)
    if current_user.id != @user.id
      @user.update(views: @user.views + 1)
    end
  end
  
end