class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :profile_image

  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users
  
  has_many :notifications, dependent: :destroy
  

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def mutual_follow?(other_user)
    self.following?(other_user) && other_user.following?(self)
  end

  def todays_books_count
    books.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
  end

  def books_from_yesterday_count
    books.where(created_at: 1.day.ago.all_day).count
  end

  def boos_day_over_day_change
    today_count = todays_books_count

    yesterday_count = books_from_yesterday_count

    return "No date for yesterday" if yesterday_count == 0

    change_ratio = ((today_count - yesterday_count).to_f / yesterday_count) * 100

    "#{change_ratio.round(0)}%"

  end

  def books_from_this_week_count
    start_of_week = Time.zone.now.beginning_of_week(:saturday)
    books.where(created_at: start_of_week..Time.zone.now.end_of_day).count
  end

  def books_from_last_week_count
    start_of_last_week = 1.week.ago.beginning_of_week(:saturday)
    end_of_last_week = start_of_last_week + 6.days
    books.where(created_at: start_of_last_week..end_of_last_week.end_of_day).count
  end

  def books_week_over_week_change
    this_week_count = books_from_this_week_count
    last_week_count = books_from_last_week_count

    return "No data for last week" if last_week_count == 0

    change_ratio = ((this_week_count - last_week_count).to_f / last_week_count) * 100
    "#{change_ratio.round(0)}%"
  end
  
  def books_count_last_7_days
    (6.downto(0)).map do |i|
      day = i.days.ago.to_date
      { days_ago: i, count: books.where(created_at: day.beginning_of_day..day.end_of_day).count }
    end
  end 
  
  
  
end
