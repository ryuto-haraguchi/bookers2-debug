class BookCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @book = Book.find(params[:book_id])
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book = @book
    if @book_comment.save
      respond_to do |format|
        format.js
      end 
    else
      render "books/show"
    end
  end

  def destroy
    @book_comment = BookComment.find(params[:id])
    @book_comment.destroy
    respond_to do |format|
      format.js
    end 
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
  
  def ensure_correct_user
    @book_comment = BookComment.find(params[:id])
    unless @book_comment.user == current_user
      redirect_to books_path
    end
  end

end
