class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :new, :create]

  def index
    @posts = Post.includes(:user).all
    @url = request.base_url

  end

  def new
    @post = Post.new
    @generate_numbers = sprintf "%04d", rand(2 - 9999)
  end

  def create
    @post = Post.new(set_post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = "Short Url was created successfully."
      redirect_to posts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def alias
    @post = Post.find_by(post_alias: params[:post_alias])
    redirect_to 'https://stackoverflow.com/questions/15484411/get-my-domain-in-rails-controller', allow_other_host: true
  end

  private

  def set_post_params
    params.require(:post).permit(:post_long_url, :post_short_url, :post_alias)
  end
end
