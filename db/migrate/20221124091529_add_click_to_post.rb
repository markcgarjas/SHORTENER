class AddClickToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :clicked, :integer, default:  0
  end
end
