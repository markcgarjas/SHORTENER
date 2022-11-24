class Post < ApplicationRecord
  validates :post_long_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :post_short_url, presence: true
  validates :post_alias, presence: true, uniqueness: true

  belongs_to :user

end
