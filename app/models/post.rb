class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  after_save :update_posts_counter
  after_destroy :update_posts_counter

  validates :title, presence: true, length: { minimum: 1, maximum: 250 }
  validates :comments_counter, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :likes_counter, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def update_posts_counter
    author.increment!(:posts_counter)
  end

  def recent_comments
    comments.includes(:author).order(created_at: :asc).limit(5)
  end
end
