class Post < ApplicationRecord
  default_scope { where(delete_at: nil) }
  validates :long_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  validates :short_url, presence: true
  validates :alias, presence: true, uniqueness: true, length: { is: 4 }, numericality: { only_integer: true }

  belongs_to :user

  def destroy
    update(delete_at: Time.current)
  end
end
