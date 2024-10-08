class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :set_user, only: [:show, :following, :followers]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def following
    @title = "Follow Users"
    @users = @user.following
    render "show_follow"
  end

  def followers
    @title = "Follower Users"
    @users = @user.followers
    render "show_follow"
  end

  def date_books
    @user = User.find(params[:id])
    @selected_date = params[:selected_date].to_date
    @books_count = @user.books.where(created_at: @selected_date.all_day).count

    respond_to do |format|
      format.js
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

end
