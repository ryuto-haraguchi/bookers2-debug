class SearchesController < ApplicationController
  before_action :authenticate_user!
  
  def search
    @model = params[:model]
    @search_method = params[:search_method]
    @query = params[:query]
    
    if @model == "user"
      @results = search_for_user(@search_method, @query) || []
    elsif @model == "book"
      @results = search_for_book(@search_method, @query) || []
    else
      @results = []
    end 
  end
  
  private
  
  def search_for_user(search_method, query)
    case search_method
    when "perfect"
      User.where(name: query)
    when "forward"
      User.where("name LIKE ?", "#{query}%")
    when "backward"
      User.where("name LIKE ?", "%#{query}")
    when "partial"
      User.where("name LIKE ?", "%#{query}%")
    end
  end

  def search_for_book(search_method, query)
    case search_method
    when "perfect"
      Book.where(title: query)
    when "forward"
      Book.where("title LIKE ?", "#{query}%")
    when "backward"
      Book.where("title LIKE ?", "%#{query}")
    when "partial"
      Book.where("title LIKE ?", "%#{query}%")
    end
  end
  
end
