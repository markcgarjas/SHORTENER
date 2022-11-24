class AddUserAgentToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :user_agent, "string"
  end
end
