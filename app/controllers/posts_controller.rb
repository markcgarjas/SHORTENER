class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :find_post_params, only: :destroy
  require 'csv'

  def index
    @posts = Post.includes(:user).all
    @url = request.base_url
    @count = Post.count
    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [User.human_attribute_name(:email),
                  Post.human_attribute_name(:id),
                  Post.human_attribute_name(:post_long_url),
                  Post.human_attribute_name(:post_short_url),
                  Post.human_attribute_name(:post_alias),
                  Post.human_attribute_name(:created_at)]
          @posts.each do |p|
            csv << [p.user.email,
                    p.id,
                    p.post_long_url,
                    p.post_short_url,
                    p.post_alias,
                    p.created_at]
          end
        end
        send_data csv_string, :filename => "posts-#{Time.current.to_s}.csv"
      }
    end
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

  def destroy
    @post.user = current_user
    @post.destroy
    redirect_to posts_path
  end

  def alias
    @post = Post.find_by(post_alias: params[:post_alias])
    @post.update_attribute(:clicked, @post.clicked + 1)
    redirect_to "#{@post.post_long_url}", allow_other_host: true
  end

  private

  def set_post_params
    params.require(:post).permit(:post_long_url, :post_short_url, :post_alias)
  end

  def find_post_params
    @post = Post.find(params[:id])
  end
end
