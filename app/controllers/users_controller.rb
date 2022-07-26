# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @pagy, @posts = pagy(@user.posts.order(created_at: :desc), items: 5)

    if current_user.nil? || ( !current_user.nil? &&  current_user.id != @user.id)
    @user.update(views: @user.views + 1)
    end
    



  end
end
