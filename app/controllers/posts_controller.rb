# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy vote]
  before_action :authenticate_user!, except: %i[show index vote]
  respond_to :js, :json, :html
  # before_action :subscribed_filter, only: :show
  #before_action :admin_filter, only: %i[ new edit create update destroy]

  # GET /posts or /posts.json

  def new
    @post = Post.new
  end

  # GET /posts/1 or /posts/1.json
  def show
    redirect_to root_path if @post.visibility == false && current_user.subscribed? == false
    @post.update(views: @post.views + 1) if current_user && (current_user.id != @post.user_id)
    
    @pagy, @comment = pagy(@post.comments.order(created_at: :desc), items: 5)
    mark_notifications_as_read
  end
  
  def index
    @pagy, @posts = pagy(Post.where(visibility: true).order(created_at: :desc), items: 5)
  end

  def premium
    @pagy, @posts = pagy(Post.where(visibility: false).order(created_at: :desc), items: 5)
    render "posts/index"
  end

  # GET /posts/new
  

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def vote
    if !current_user.liked? @post
      @post.liked_by current_user
    elsif current_user.liked? @post
      @post.unliked_by current_user
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
    redirect_to @post, status: :moved_permanently if params[:id] != @post.slug
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :body, :category_id, :visibility)
  end

  def  mark_notifications_as_read
    if current_user
      notifications_to_mark_as_read = @post.notifications_as_post.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end
