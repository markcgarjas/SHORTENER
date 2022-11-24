class Post < ApplicationRecord
  validates :post_long_url, presence: true
  validates :post_short_url, presence: true
  validates :post_alias, uniqueness: true

  belongs_to :user
end
