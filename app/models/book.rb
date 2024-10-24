class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  acts_as_taggable_on :tags

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  scope :popular, -> {
    left_joins(:favorites)
      .group("books.id")
      .order("COUNT(favorites.id) DESC")
  }

  after_create do
    user.followers.each do |follower|
      notifications.create(user_id: follower.id)
    end
  end  

end


