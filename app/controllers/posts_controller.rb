class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_post, only: :destroy
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
                  Post.human_attribute_name(:long_url),
                  Post.human_attribute_name(:short_url),
                  Post.human_attribute_name(:alias),
                  Post.human_attribute_name(:created_at)]
          @posts.each do |p|
            csv << [p.user.email,
                    p.id,
                    p.long_url,
                    p.short_url,
                    p.alias,
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
    @post = Post.new(post_params)
    @post.user = current_user
    if Rails.env.development?
      @post.ip_address = Net::HTTP.get(URI.parse('http://checkip.amazonaws.com/')).squish
    else
      @post.ip_address = request.remote_ip
    end
    @post.user_agent = request.user_agent
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
    @post = Post.find_by(alias: params[:alias])
    @post.update_attribute(:clicked, @post.clicked + 1)
    redirect_to "#{@post.long_url}", allow_other_host: true
  end

  private

  def post_params
    params.require(:post).permit(:long_url, :short_url, :alias)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
