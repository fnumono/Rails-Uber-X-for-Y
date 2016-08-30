class AddBannedToClient < ActiveRecord::Migration
  def change
    add_column :clients, :banned, :boolean, default: false
  end
end
