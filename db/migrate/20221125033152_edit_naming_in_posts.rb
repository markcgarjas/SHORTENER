class EditNamingInPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :short_url, :string
    add_column :posts, :long_url, :string
    add_column :posts, :alias, :string
    remove_column :posts, :post_short_url
    remove_column :posts, :post_long_url
    remove_column :posts, :post_alias
  end
end
