class AddIpAddressToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :ip_address,:string
  end
end
