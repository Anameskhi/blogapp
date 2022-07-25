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

  def show_post
    @post = Post.includes(:user, :comments).find(params[:id])
  end
end
