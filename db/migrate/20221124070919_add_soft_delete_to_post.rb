class AddSoftDeleteToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :delete_at, :datetime, default: nil
  end
end
