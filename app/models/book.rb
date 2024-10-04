class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  scope :popular_in_last_week, -> {
    left_joins(:favorites)
      .group("books.id")
      .order("COUNT(favorites.id) DESC")
  }

end


