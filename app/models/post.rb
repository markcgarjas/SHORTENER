class Post < ApplicationRecord
  default_scope { where(delete_at: nil) }
  validates :post_long_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :post_short_url, presence: true
  validates :post_alias, presence: true, uniqueness: true, length: { minimum: 4, maximum: 4 }, numericality: { only_integer: true }

  belongs_to :user

  def destroy
    update(delete_at: Time.now)
  end
end
